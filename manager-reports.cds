// Put this file in srv/ (next to services.cds). PDF download and email report for the Manager.
using { asset.lifecycle.db as db } from '../db/report-log';
using AssetManagerService from './services';

extend service AssetManagerService with {
  @readonly entity ReportLogs as projection on db.ReportLog;
  function exportPdf(filter : String) returns LargeString;                     // base64 PDF (FR-022)
  action   emailReport(filter : String, to : String) returns String;           // PDF by email (FR-023)
}
