// Put this file in db/ (next to schema.cds). Audit trail for exports and emails (NFR-012).
namespace asset.lifecycle.db;
using { cuid, managed } from '@sap/cds/common';

entity ReportLog : cuid, managed {
  action     : String(20);     // PDF_DOWNLOAD | EMAIL
  filterText : String(1000);   // the filters that were applied
  recipient  : String(120);
  rowCount   : Integer;
  outcome    : String(20);     // OK | FAILED
  message    : String(300);
}
