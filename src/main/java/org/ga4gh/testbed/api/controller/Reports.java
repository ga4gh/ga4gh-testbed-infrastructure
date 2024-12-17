package org.ga4gh.testbed.api.controller;

import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import com.fasterxml.jackson.annotation.JsonView;
import org.ga4gh.testbed.api.model.Report;
import org.ga4gh.testbed.api.utils.DTO.ReportCountDTO;
import org.ga4gh.testbed.api.utils.SerializeView;
import org.ga4gh.testbed.api.utils.hibernate.TestbedApiHibernateUtil;
import org.ga4gh.testbed.api.utils.requesthandler.report.CreateReportHandler;
import org.ga4gh.testbed.api.utils.requesthandler.report.DeleteReportHandler;
import org.ga4gh.testbed.api.utils.requesthandler.report.ShowReportHandler;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/reports")
public class Reports {

    @Autowired
    private TestbedApiHibernateUtil hibernateUtil;

    @Autowired
    private ShowReportHandler showReport;

    @Autowired
    private CreateReportHandler createReport;

    @Autowired
    private DeleteReportHandler deleteReport;

    @GetMapping
    @JsonView(SerializeView.ReportSimple.class)
    public List<Report> getReports(
        @RequestParam(name = "listPrivate", required = false, defaultValue = "false") Boolean listPrivate
    ) {
        if (listPrivate) {
            return hibernateUtil.listEntityObject(Report.class);
        }
        
        return hibernateUtil.listEntityObject(Report.class)
                            .stream()
                            .filter(r -> !r.getIsPrivate())
                            .collect(Collectors.toList());
    }

    @GetMapping(path = "/getReportsByTestbed/")
    @JsonView(SerializeView.ReportSimple.class)
    public Map<String, List<Report>> getReportsByTestbed() {
        List<Report> reports = hibernateUtil.listEntityObject(Report.class);
        Map<String, List<Report>> reportGroup = showReport.getReportsByTestbed(reports);
        return reportGroup;
    }

    @GetMapping(path = "/{reportId:.+}")
    @JsonView(SerializeView.ReportFull.class)
    public Report getReport(
        @PathVariable String reportId
    ) {
        return showReport.prepare(reportId).handleRequest();
    }

    @PostMapping
    @JsonView(SerializeView.ReportFull.class)
    public Report postReport(
        @RequestHeader("GA4GH-TestbedReportSeriesId") String reportSeriesId,
        @RequestHeader("GA4GH-TestbedReportSeriesToken") String reportSeriesToken,
        @RequestBody Report report
    ) throws Exception {
        return createReport.prepare(reportSeriesId, reportSeriesToken, report).handleRequest();
    }

    @DeleteMapping("/{reportId:.+}")
    @JsonView(SerializeView.ReportFull.class)
    public Report deleteReport(
        @PathVariable String reportId,
        @RequestHeader("GA4GH-TestbedReportSeriesId") String reportSeriesId,
        @RequestHeader("GA4GH-TestbedReportSeriesToken") String reportSeriesToken
    ) throws Exception {
        return deleteReport.prepare(reportId, reportSeriesId, reportSeriesToken).handleRequest();
    }

    @RequestMapping(value = "/reportCounts/", method = RequestMethod.GET)
    public List<ReportCountDTO> getSubmittedReportsCount() {
        return showReport.getSubmittedReportsCount();
    }

}
