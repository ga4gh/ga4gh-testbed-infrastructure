insert into specification values (
    'refget',
    'refget',
    'Reference sequence retrieval API',
    'https://github.com/samtools/hts-specs',
    'https://samtools.github.io/hts-specs/refget.html'
), (
    'rnaget',
    'RNAget',
    'Expression matrix retrieval API',
    'https://github.com/ga4gh-rnaseq/schema',
    'https://ga4gh-rnaseq.github.io/schema/docs/index.html'
);

insert into organization values (
    'org.ga4gh',
    'Global Alliance for Genomics and Health',
    'https://ga4gh.org'
);

insert into github_user values (
    'ga4gh-user'
);

insert into github_user_organization values (
    0,
    'MEMBER',
    'ga4gh-user',
    'org.ga4gh'
);

insert into platform values (
    'org.ga4gh.refget.starterkit',
    'Refget Starter Kit',
    'GA4GH Starter Kit deployment of Refget specification',
    'org.ga4gh'
), (
    'org.ga4gh.rnaget.starterkit',
    'RNAget Starter Kit',
    'GA4GH Starter Kit for RNAget specification',
    'org.ga4gh'
);

insert into testbed values (
    'refget-compliance',
    'Refget Compliance Suite',
    'Test compliance of Refget services to specification',
    'https://github.com/ga4gh/refget-compliance-suite',
    'https://hub.docker.com/repository/docker/ga4gh/refget-compliance-suite',
    'https://dockstore.org/containers/registry.hub.docker.com/ga4gh/refget-compliance-suite'
), (
    'rnaget-compliance',
    'RNAget Compliance Suite',
    'Test compliance of RNAget services to specification',
    'https://github.com/ga4gh-rnaseq/rnaget-compliance-suite',
    'https://hub.docker.com',
    'https://dockstore.org'
);

insert into testbed_version values (
    0,
    '1.2.6',
    'refget-compliance'
), (
    1,
    '1.0.0',
    'rnaget-compliance'
);

insert into specification_testbed values
    (0, 'refget', 'refget-compliance'),
    (1, 'rnaget', 'rnaget-compliance');
insert into specification_platform values
    (0, 'refget', 'org.ga4gh.refget.starterkit'),
    (1, 'rnaget', 'org.ga4gh.rnaget.starterkit');

insert into report_series values (
    '1edb5213-52a2-434f-a7b8-b101fea8fb30',
    'k4A2I1FUJrbpN70v4FXrrAqwvcamnZyB',
    'dcaa1ff102a989efeaebef66e950216d86160303689120e9e76d88d4a70bd003', /* plaintext token is K5pLbwScVu8rEoLLj8pRy5Wv7EXTVahn */
    'refget-compliance',
    'org.ga4gh.refget.starterkit'
),(
    '483382e9-f92b-466d-9427-154d56a75fcf',
    'JQhtM8FvjgaQaNbxTFbawJTWFjbdiiSL',
    '463bdadca28c206693339fcc5465c9885395a7e03deff93ce1e851c5561bae36', /* plaintext token is l0HiRbbpjVDKc6k3tQ2skzROB1oAP2IV */
    'rnaget-compliance',
    'org.ga4gh.rnaget.starterkit'
);

insert into summary (
    unknown,
    passed,
    warned,
    failed,
    skipped
) values
(
    0,
    10,
    2,
    0,
    0
), 
(
    0,
    12,
    0,
    0,
    0
), 
(
    0,
    8,
    2,
    2,
    0
), 
(
    0,
    10,
    2,
    0,
    0
),
(
    0,
    7,
    2,
    3,
    0
), 
(
    0,
    9,
    2,
    0,
    1
);

insert into report (
    id,
    schema_name,
    schema_version,
    input_parameters,
    start_time,
    end_time,
    status ,
    fk_summary_id,
    fk_report_series_id
) values (
    '01d0e947-5975-4786-a755-5025fec7416d',
    'ga4gh-testbed-report',
    '0.1.0',
    '{ "url": "https://testsite.ga4gh.org/api"}',
    '2021-10-20T12:00:00Z',
    '2021-10-20T12:00:20Z',
    'UNKNOWN',
    1,
    '1edb5213-52a2-434f-a7b8-b101fea8fb30'
);

insert into phase (
    phase_name,
    phase_description,
    start_time,
    end_time,
    status,
    fk_summary_id,
    fk_report_id
) values (
    'sequence',
    'refget sequence endpoint',
    '2021-10-20T12:00:00Z',
    '2021-10-20T12:00:05Z',
    'PASSED',
    2,
    '01d0e947-5975-4786-a755-5025fec7416d'
),(
    'metadata',
    'refget metadata endpoint',
    '2021-10-20T12:00:05Z',
    '2021-10-20T12:00:10Z',
    'PASSED',
    3,
    '01d0e947-5975-4786-a755-5025fec7416d'
),(
    'service-info',
    'refget service-info endpoint',
    '2021-10-20T12:00:10Z',
    '2021-10-20T12:00:15Z',
    'PASSED',
    4,
    '01d0e947-5975-4786-a755-5025fec7416d'
);

insert into testbed_test (
    test_name,
    test_description,
    start_time,
    end_time,
    status,
    fk_summary_id,
    fk_phase_id
) values (
    'test_sequence_circular',
    'Test to check if server passes all the edge cases related to circular queries',
    '2021-10-20T12:00:00Z',
    '2021-10-20T12:00:03Z',
    'PASSED',
    5,
    1
),(
    'test_sequence_query_by_trunc512',
    'Test to check if server returns 200 using I test sequence trunc512 and appropriate headers if the server supports trunc512',
    '2021-10-20T12:00:03Z',
    '2021-10-20T12:00:06Z',
    'FAILED',
    6,
    1
);

insert into testbed_case (
    case_name,
    case_description,
    start_time,
    end_time,
    status,
    message,
    fk_testbed_test_id 
) values (
    'case 1',
    'test for seq 1',
    '2021-10-20T12:00:00Z',
    '2021-10-20T12:00:01Z',
    'PASSED',
    'server reponds as expected',
    1
),(
    'case 2',
    'test for seq 2',
    '2021-10-20T12:00:01Z',
    '2021-10-20T12:00:02Z',
    'FAILED',
    'test case failed',
    1
);

insert into testbed_case (
	case_name,
    case_description,
    start_time,
    end_time,
    status,
    message,
    fk_testbed_test_id 
) values (
    'case 1',
    'test with incorrect trunc512',
    '2021-10-20T12:00:03Z',
    '2021-10-20T12:00:04Z',
    'UNKNOWN',
    'unknown server response',
    2
),(
    'case 2',
    'test with correct trunc512',
    '2021-10-20T12:00:04Z',
    '2021-10-20T12:00:05Z',
    'WARNING',
    'server responds with a warning',
    2
);

insert into log_message(
    message,
    fk_testbed_case_id
) values (
    'log message 1',
    1
),(
    'log message 2',
    2
),(
    'log message 3',
    3
),(
    'log message 4',
    4
);