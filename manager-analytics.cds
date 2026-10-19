// Put this file in srv/  (next to services.cds). No other file needs editing.
using { asset.lifecycle.db as db } from '../db/schema';
using AssetManagerService from './services';

// One flat row per asset so filters (category, location, department, ...) and charts work together
extend service AssetManagerService with {
  @readonly @cds.redirection.target: false
  entity AssetFacts as select from db.Asset as a {
    key a.asset_id,
    a.asset_tag,
    a.serial_number,
    a.model,
    a.assetCategory.name           as category,
    a.status,
    a.location,
    a.current_holder.full_name     as owner,
    a.current_holder.department.name as department,
    a.vendor.name                  as vendor,
    a.purchase_date,
    a.purchase_cost,
    1                              as assetCount : Integer
  };
}

annotate AssetManagerService.AssetFacts with @(
  // ---- analytics: lets the ALP group and count ----
  Aggregation.ApplySupported: {
    Transformations: [ 'aggregate', 'groupby', 'filter', 'search', 'identity' ],
    GroupableProperties: [ category, status, location, owner, department, vendor, purchase_date, asset_tag ],
    AggregatableProperties: [ { Property: assetCount }, { Property: purchase_cost } ]
  },
  Aggregation.CustomAggregate #assetCount : 'Edm.Int32',
  Aggregation.CustomAggregate #purchase_cost : 'Edm.Decimal',

  // ---- filter bar (from the Manager slide) ----
  UI.SelectionFields: [ purchase_date, status, category, location, department ],

  // ---- main chart: assets by lifecycle status ----
  UI.Chart #Status: {
    Title: 'Assets by lifecycle status', ChartType: #Donut,
    Dimensions: [ status ],
    DimensionAttributes: [ { Dimension: status, Role: #Category } ],
    Measures: [ assetCount ],
    MeasureAttributes: [ { Measure: assetCount, Role: #Axis1, DataPoint: '@UI.DataPoint#Count' } ]
  },
  UI.DataPoint #Count: { Value: assetCount, Title: 'Assets' },

  UI.PresentationVariant: {
    Visualizations: [ '@UI.Chart#Status', '@UI.LineItem' ],
    SortOrder: [ { Property: asset_tag, Descending: false } ]
  },

  // ---- table ----
  UI.LineItem: [
    { Value: asset_tag, Label: 'Asset' }, { Value: serial_number }, { Value: model },
    { Value: category }, { Value: status }, { Value: owner }, { Value: location },
    { Value: department }, { Value: vendor }
  ]
);

annotate AssetManagerService.AssetFacts with {
  asset_id      @UI.Hidden;
  assetCount    @Common.Label: 'Assets';
  category      @Common.Label: 'Category';
  status        @Common.Label: 'Status';
  location      @Common.Label: 'Location';
  department    @Common.Label: 'Department';
  owner         @Common.Label: 'Owner';
  vendor        @Common.Label: 'Vendor';
  purchase_date @Common.Label: 'Purchase date';
};
