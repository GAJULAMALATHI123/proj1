// Put this file in srv/. Annotations for the four master data lists inside the Admin app.
using AssetAdminService as A from './services';

annotate A.Employees with @(
  UI.HeaderInfo: { TypeName: 'Employee', TypeNamePlural: 'Employees', Title: { Value: full_name }, Description: { Value: email } },
  UI.SelectionFields: [ full_name, department_dept_id, location, status ],
  UI.LineItem: [ { Value: full_name }, { Value: email }, { Value: phone },
    { Value: department.name, Label: 'Department' }, { Value: location }, { Value: status } ],
  UI.Facets: [ { $Type: 'UI.ReferenceFacet', ID: 'Main', Label: 'Details', Target: '@UI.FieldGroup#Main' } ],
  UI.FieldGroup #Main: { Data: [ { Value: full_name }, { Value: email }, { Value: phone },
    { Value: department_dept_id }, { Value: location }, { Value: status } ] }
);
annotate A.Employees with {
  department @(Common.Label: 'Department', Common.Text: department.name, Common.TextArrangement: #TextOnly,
    Common.ValueList: { CollectionPath: 'Departments', Parameters: [
      { $Type: 'Common.ValueListParameterInOut', LocalDataProperty: department_dept_id, ValueListProperty: 'dept_id' },
      { $Type: 'Common.ValueListParameterDisplayOnly', ValueListProperty: 'name' } ] });
};

annotate A.Departments with @(
  UI.HeaderInfo: { TypeName: 'Department', TypeNamePlural: 'Departments', Title: { Value: name }, Description: { Value: cost_center } },
  UI.SelectionFields: [ name, cost_center, is_active ],
  UI.LineItem: [ { Value: name }, { Value: cost_center }, { Value: is_active } ],
  UI.Facets: [ { $Type: 'UI.ReferenceFacet', ID: 'Main', Label: 'Details', Target: '@UI.FieldGroup#Main' } ],
  UI.FieldGroup #Main: { Data: [ { Value: name }, { Value: cost_center }, { Value: is_active } ] }
);

annotate A.AssetCategories with @(
  UI.HeaderInfo: { TypeName: 'Category', TypeNamePlural: 'Categories', Title: { Value: name } },
  UI.SelectionFields: [ name, is_active ],
  UI.LineItem: [ { Value: name }, { Value: lifespan_months }, { Value: is_active } ],
  UI.Facets: [ { $Type: 'UI.ReferenceFacet', ID: 'Main', Label: 'Details', Target: '@UI.FieldGroup#Main' } ],
  UI.FieldGroup #Main: { Data: [ { Value: name }, { Value: lifespan_months }, { Value: is_active } ] }
);

annotate A.Vendors with @(
  UI.HeaderInfo: { TypeName: 'Vendor', TypeNamePlural: 'Vendors', Title: { Value: name }, Description: { Value: email } },
  UI.SelectionFields: [ name, is_active ],
  UI.LineItem: [ { Value: vendor_id, Label: 'Vendor ID' }, { Value: name }, { Value: email }, { Value: is_active } ],
  UI.Facets: [ { $Type: 'UI.ReferenceFacet', ID: 'Main', Label: 'Details', Target: '@UI.FieldGroup#Main' } ],
  UI.FieldGroup #Main: { Data: [ { Value: name }, { Value: email }, { Value: is_active } ] }
);
