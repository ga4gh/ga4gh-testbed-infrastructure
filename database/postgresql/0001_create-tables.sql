/* ################################################## */
/* # USER / ORGANIZATION                            # */
/* ################################################## */

CREATE TABLE IF NOT EXISTS github_user
(
    github_id text PRIMARY KEY
);

CREATE TABLE IF NOT EXISTS organization
(
    id text PRIMARY KEY,
    organization_name text NOT NULL,
    organization_url text NOT NULL
);

CREATE TABLE IF NOT EXISTS user_organization
(
    id serial PRIMARY KEY,
    role text NOT NULL,
    fk_user_github_id text NOT NULL,
    fk_organization_id text NOT NULL,
    foreign key (fk_user_github_id) references github_user(github_id),
    foreign key (fk_organization_id) references organization(id)
);

/* ################################################## */
/* # PLATFORM                                       # */
/* ################################################## */

CREATE TABLE IF NOT EXISTS platform
(
    id text PRIMARY KEY,
    platform_name text NOT NULL,
    platform_description text NOT NULL,
    fk_organization_id text NOT NULL,
    foreign key (fk_organization_id) references organization(id)
);

/* ################################################## */
/* # SPECIFICATION                                  # */
/* ################################################## */

CREATE TABLE IF NOT EXISTS specification
(
    id text PRIMARY KEY,
    spec_name text NOT NULL,
    spec_description text NOT NULL,
    github_url text NOT NULL,
    documentation_url text NOT NULL
);

CREATE TABLE IF NOT EXISTS specification_platform
(
    id serial PRIMARY KEY,
    fk_specification_id text NOT NULL,
    fk_platform_id text NOT NULL,
    foreign key (fk_specification_id) references specification(id),
    foreign key (fk_platform_id) references platform(id)
);

/* ################################################## */
/* # TESTBED                                        # */
/* ################################################## */

CREATE TABLE IF NOT EXISTS testbed
(
    id text PRIMARY KEY,
    testbed_name text NOT NULL,
    testbed_description text NOT NULL,
    repo_url text NOT NULL,
    dockerhub_url text,
    dockstore_url text
);

CREATE TABLE IF NOT EXISTS testbed_version
(
    id serial PRIMARY KEY,
    testbed_version text NOT NULL,
    fk_testbed_id text NOT NULL,
    foreign key (fk_testbed_id) references testbed(id)
);

CREATE TABLE IF NOT EXISTS specification_testbed
(
    id serial PRIMARY KEY,
    fk_specification_id text NOT NULL,
    fk_testbed_id text NOT NULL,
    foreign key (fk_specification_id) references specification(id),
    foreign key (fk_testbed_id) references testbed(id)
);

/* ################################################## */
/* # REPORT                                         # */
/* ################################################## */

CREATE TABLE IF NOT EXISTS summary
(
    id serial PRIMARY KEY,
    unknown integer NOT NULL,
    passed integer NOT NULL,
    warned integer NOT NULL,
    failed integer NOT NULL,
    skipped integer NOT NULL
);

CREATE TABLE IF NOT EXISTS report_series
(
    id text PRIMARY KEY,
    token_salt text NOT NULL,
    token_hash text NOT NULL,
    fk_testbed_id text NOT NULL,
    fk_platform_id text NOT NULL,
    foreign key (fk_testbed_id) references testbed(id),
    foreign key (fk_platform_id) references platform(id)
);

CREATE TABLE IF NOT EXISTS report
(
    id text PRIMARY KEY,
    schema_name text NOT NULL,
    schema_version text NOT NULL,
    input_parameters json NOT NULL,
    start_time timestamp without time zone NOT NULL,
    end_time timestamp without time zone NOT NULL,
    status text NOT NULL,
    fk_summary_id integer NOT NULL,
    fk_report_series_id text NOT NULL,
    foreign key (fk_summary_id) references summary(id),
    foreign key (fk_report_series_id) references report_series(id)
);

CREATE TABLE IF NOT EXISTS phase
(
    id serial PRIMARY KEY,
    phase_name text NOT NULL,
    phase_description text NOT NULL,
    start_time timestamp without time zone NOT NULL,
    end_time timestamp without time zone NOT NULL,
    status text NOT NULL,
    fk_summary_id integer NOT NULL,
    fk_report_id text NOT NULL,
    foreign key (fk_summary_id) references summary(id),
    foreign key (fk_report_id) references report(id)
);

CREATE TABLE IF NOT EXISTS testbed_test
(
    id serial PRIMARY KEY,
    test_name text NOT NULL,
    test_description text NOT NULL,
    start_time timestamp without time zone NOT NULL,
    end_time timestamp without time zone NOT NULL,
    status text NOT NULL,
    fk_summary_id integer NOT NULL,
    fk_phase_id integer NOT NULL,
    foreign key (fk_summary_id) references summary(id),
    foreign key (fk_phase_id) references phase(id)  
);

CREATE TABLE IF NOT EXISTS testbed_case
(
    id serial PRIMARY KEY,
    case_name text NOT NULL,
    case_description text NOT NULL,
    start_time timestamp without time zone NOT NULL,
    end_time timestamp without time zone NOT NULL,
    status text NOT NULL,
    message text NOT NULL,
    fk_testbed_test_id integer,
    foreign key (fk_testbed_test_id) references testbed_test(id)
);

CREATE TABLE IF NOT EXISTS log_message
(
    id serial PRIMARY KEY,
    message text NOT NULL,
    fk_testbed_case_id integer NOT NULL,
    foreign key (fk_testbed_case_id) references testbed_case(id)
);