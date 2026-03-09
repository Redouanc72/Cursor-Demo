import { LightningElement, wire } from 'lwc';
import getDashboardData from '@salesforce/apex/ExpeditionDashboardController.getDashboardData';
import { refreshApex } from '@salesforce/apex';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

/** Approximate lunar (or demo) coordinates for landing sites — map displays at these lat/long. */
const LANDING_SITE_COORDS = {
    'Mare Tranquillitatis': { Latitude: 0.67, Longitude: 23.43 },
    'Mare Imbrium': { Latitude: 34.72, Longitude: -14.91 },
    'Mare Serenitatis': { Latitude: 28.0, Longitude: 17.5 },
    'Mare Fecunditatis': { Latitude: -2.0, Longitude: 53.0 },
    'Mare Crisium': { Latitude: 17.0, Longitude: 59.0 },
    'South Pole': { Latitude: -89.9, Longitude: 0 },
    'Copernicus Crater': { Latitude: 9.62, Longitude: -20.08 },
    'Tycho Crater': { Latitude: -43.31, Longitude: -11.36 },
    'default': { Latitude: 12.0, Longitude: 45.0 }
};

const REFRESH_INTERVAL_MS = 30 * 1000;
const COMPLIANCE_CLEARED = 'Cleared';
const COMPLIANCE_BLOCKED = 'Blocked';
const COMPLIANCE_PENDING = 'Pending';

export default class LunarExpeditionDashboard extends LightningElement {
    wiredResult;
    expeditions = [];
    byMonth = [];
    byLandingSite = [];
    mapMarkers = [];
    isLoading = true;
    error;

    @wire(getDashboardData)
    wiredDashboard(result) {
        this.wiredResult = result;
        if (result.data !== undefined) {
            this.expeditions = (result.data.expeditions || []).map((e) => ({
                ...e,
                launchDateFormatted: this.formatDate(e.launchDate),
                countdownText: this.getCountdownText(e.launchDate),
                complianceVariant: this.getComplianceVariant(e.complianceStatus),
                complianceLabel: e.complianceStatus || COMPLIANCE_PENDING,
                explorerInitials: this.getInitials(e.explorerName)
            }));
            this.byMonth = result.data.byMonth || [];
            this.byLandingSite = result.data.byLandingSite || [];
            this.mapMarkers = this.buildMapMarkers(result.data.expeditions || []);
            this.error = undefined;
        } else if (result.error) {
            this.error = result.error;
            this.expeditions = [];
            this.byMonth = [];
            this.byLandingSite = [];
            this.mapMarkers = [];
        }
        if (result.data !== undefined || result.error !== undefined) {
            this.isLoading = false;
        }
    }

    connectedCallback() {
        this.refreshTimer = setInterval(() => this.handleRefresh(), REFRESH_INTERVAL_MS);
    }

    disconnectedCallback() {
        if (this.refreshTimer) clearInterval(this.refreshTimer);
    }

    get hasExpeditions() {
        return Array.isArray(this.expeditions) && this.expeditions.length > 0;
    }

    get hasNoData() {
        return !this.isLoading && !this.error && !this.hasExpeditions;
    }

    get hasCharts() {
        return (this.byMonth && this.byMonth.length > 0) || (this.byLandingSite && this.byLandingSite.length > 0);
    }

    get maxChartValue() {
        const monthMax = (this.byMonth || []).reduce((m, b) => Math.max(m, b.value || 0), 0);
        const siteMax = (this.byLandingSite || []).reduce((m, b) => Math.max(m, b.value || 0), 0);
        return Math.max(1, monthMax, siteMax);
    }

    get monthChartBars() {
        const max = this.maxChartValue;
        return (this.byMonth || []).map((b) => {
            const widthPct = max ? Math.round((100 * (b.value || 0)) / max) : 0;
            return { ...b, widthPct, barStyle: `width: ${widthPct}%` };
        });
    }

    get siteChartBars() {
        const max = this.maxChartValue;
        return (this.byLandingSite || []).map((b) => {
            const widthPct = max ? Math.round((100 * (b.value || 0)) / max) : 0;
            return { ...b, widthPct, barStyle: `width: ${widthPct}%` };
        });
    }

    formatDate(dateVal) {
        if (!dateVal) return '—';
        const d = typeof dateVal === 'string' ? new Date(dateVal) : new Date(dateVal + 'T12:00:00');
        return isNaN(d.getTime()) ? '—' : d.toLocaleDateString(undefined, { year: 'numeric', month: 'short', day: 'numeric' });
    }

    getCountdownText(launchDate) {
        if (!launchDate) return '—';
        const d = typeof launchDate === 'string' ? new Date(launchDate) : new Date(launchDate + 'T12:00:00');
        if (isNaN(d.getTime())) return '—';
        const now = new Date();
        const diffMs = d.getTime() - now.getTime();
        const diffDays = Math.floor(diffMs / (24 * 60 * 60 * 1000));
        if (diffDays < 0) return 'Launched';
        if (diffDays === 0) return 'Today';
        if (diffDays === 1) return '1 day';
        return `${diffDays} days`;
    }

    getComplianceVariant(status) {
        if (status === COMPLIANCE_CLEARED) return 'success';
        if (status === COMPLIANCE_BLOCKED) return 'error';
        return 'warning';
    }

    getInitials(name) {
        if (!name || typeof name !== 'string') return '?';
        const parts = name.trim().split(/\s+/).filter(Boolean);
        if (parts.length === 0) return '?';
        if (parts.length === 1) return parts[0].slice(0, 2).toUpperCase();
        return (parts[0][0] + parts[parts.length - 1][0]).toUpperCase();
    }

    buildMapMarkers(expeditions) {
        const seen = new Set();
        return expeditions
            .filter((e) => e.landingSite)
            .map((e) => {
                const key = e.landingSite;
                if (seen.has(key)) return null;
                seen.add(key);
                const loc = LANDING_SITE_COORDS[e.landingSite] || LANDING_SITE_COORDS.default;
                return {
                    location: { Latitude: loc.Latitude, Longitude: loc.Longitude },
                    title: e.landingSite,
                    description: `Landing site: ${e.landingSite}. Expeditions: ${e.expeditionName || '—'}`
                };
            })
            .filter(Boolean);
    }

    async handleRefresh() {
        if (!this.wiredResult || !this.wiredResult.data) return;
        this.isLoading = true;
        try {
            await refreshApex(this.wiredResult);
            this.dispatchEvent(new ShowToastEvent({ title: 'Refreshed', message: 'Dashboard data updated.', variant: 'success' }));
        } catch (err) {
            this.dispatchEvent(new ShowToastEvent({ title: 'Refresh failed', message: (err && err.body && err.body.message) || 'Unknown error', variant: 'error' }));
        } finally {
            this.isLoading = false;
        }
    }
}
