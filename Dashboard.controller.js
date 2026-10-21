// Save as  webapp/ext/view/Dashboard.controller.js  in the Manager app
sap.ui.define([
  "sap/fe/core/PageController",
  "sap/ui/model/json/JSONModel",
  "sap/ui/core/Element",
  "managerdashboard/ext/Nav"
], function (PageController, JSONModel, Element, Nav) {
  "use strict";

  return PageController.extend("managerdashboard.ext.view.Dashboard", {

    onInit: function () {
      PageController.prototype.onInit.apply(this, arguments);
      this.getView().setModel(new JSONModel({
        total: 0, available: 0, assigned: 0, maintenance: 0, retired: 0,
        pAvailable: 0, pAssigned: 0, pMaintenance: 0, pRetired: 0
      }), "kpi");
      var self = this;
      this.getView().addEventDelegate({
        onAfterRendering: function () {
          if (self._wired) { return; }
          self._wired = true;
          // refresh the cards whenever the user clicks Go in the filter bar
          setTimeout(function () {
            var fb = Element.registry.filter(function (e) { return e.isA && e.isA("sap.ui.mdc.FilterBar"); })[0];
            if (fb) { fb.attachSearch(function () { setTimeout(function () { self.refreshKpis(); }, 800); }); }
            self.refreshKpis();
          }, 1500);
        }
      });
    },

    // counts per status for the current selection, calculated by the service
    refreshKpis: function () {
      var self = this;
      var model = this.getAppComponent().getModel();
      var f = Nav.getFilter();
      var apply = (f ? "filter(" + f + ")/" : "") + "groupby((status),aggregate(assetCount))";
      fetch(model.getServiceUrl() + "AssetFacts?$apply=" + encodeURIComponent(apply), { headers: { Accept: "application/json" } })
        .then(function (r) { return r.json(); })
        .then(function (j) {
          var c = {};
          (j.value || []).forEach(function (r) { c[r.status] = Number(r.assetCount) || 0; });
          var total = Object.keys(c).reduce(function (a, k) { return a + c[k]; }, 0);
          var pct = function (n) { return total ? Math.round(n * 100 / total) : 0; };
          self.getView().getModel("kpi").setData({
            total: total,
            available: c.AVAILABLE || 0, assigned: c.ASSIGNED || 0, maintenance: c.MAINTENANCE || 0, retired: c.RETIRED || 0,
            pAvailable: pct(c.AVAILABLE || 0), pAssigned: pct(c.ASSIGNED || 0),
            pMaintenance: pct(c.MAINTENANCE || 0), pRetired: pct(c.RETIRED || 0)
          });
        })
        .catch(function () { /* cards keep their last values */ });
    },

    onRowPress: function (oEvent) {
      var ctx = (oEvent.getParameter && (oEvent.getParameter("bindingContext") ||
                (oEvent.getParameter("listItem") && oEvent.getParameter("listItem").getBindingContext()))) ||
                (oEvent.getSource && oEvent.getSource().getBindingContext && oEvent.getSource().getBindingContext());
      if (ctx) {
        this.getAppComponent().getRouter().navTo("AssetFactsObjectPage", { key: "asset_id=" + ctx.getProperty("asset_id") });
      }
    },

    onAttention:   function () { Nav.goAttention(); },
    onDownloadPdf: function () { Nav.downloadPdf(); },
    onEmailReport: function () { Nav.emailReport(); }
  });
});
