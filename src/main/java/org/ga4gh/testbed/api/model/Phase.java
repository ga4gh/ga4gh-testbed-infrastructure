package org.ga4gh.testbed.api.model;

import java.time.LocalDateTime;
import java.util.List;
import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
import javax.persistence.OneToOne;
import javax.persistence.Table;
import com.fasterxml.jackson.annotation.JsonFormat;
import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.annotation.JsonView;
import com.fasterxml.jackson.databind.PropertyNamingStrategies;
import com.fasterxml.jackson.databind.annotation.JsonDeserialize;
import com.fasterxml.jackson.databind.annotation.JsonNaming;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;
import com.fasterxml.jackson.datatype.jsr310.deser.LocalDateTimeDeserializer;
import com.fasterxml.jackson.datatype.jsr310.ser.LocalDateTimeSerializer;
import org.ga4gh.starterkit.common.constant.DateTimeConstants;
import org.ga4gh.starterkit.common.hibernate.HibernateEntity;
import org.ga4gh.testbed.api.utils.SerializeView;
import org.hibernate.Hibernate;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Entity
@Table(name = "phase")
@Setter
@Getter
@NoArgsConstructor
@JsonInclude(JsonInclude.Include.NON_EMPTY)
@JsonNaming(PropertyNamingStrategies.SnakeCaseStrategy.class)
public class Phase implements HibernateEntity<Integer> {

    @Id
    @Column(name = "id", updatable = false, nullable = false)
    @GeneratedValue(strategy = GenerationType.AUTO)
    @JsonView(SerializeView.Never.class)
    private Integer id;

    @Column(name = "phase_name")
    @JsonView(SerializeView.Always.class)
    private String phaseName;

    @Column(name = "phase_description")
    @JsonView(SerializeView.Always.class)
    private String phaseDescription;

    @Column(name = "start_time")
    @JsonDeserialize(using = LocalDateTimeDeserializer.class)
    @JsonSerialize(using = LocalDateTimeSerializer.class)
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = DateTimeConstants.DATE_FORMAT)
    @JsonView(SerializeView.Always.class)
    private LocalDateTime startTime;

    @Column(name = "end_time")
    @JsonDeserialize(using = LocalDateTimeDeserializer.class)
    @JsonSerialize(using = LocalDateTimeSerializer.class)
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = DateTimeConstants.DATE_FORMAT)
    @JsonView(SerializeView.Always.class)
    private LocalDateTime endTime;

    @Column(name = "status")
    @JsonView(SerializeView.Always.class)
    private Status status;

    @OneToOne(cascade = CascadeType.ALL,
              orphanRemoval = true)
    @JoinColumn(name = "fk_summary_id", referencedColumnName = "id")
    @JsonView(SerializeView.ReportFull.class)
    private Summary summary;

    @OneToMany(mappedBy = "phase",
               fetch = FetchType.LAZY,
               cascade = CascadeType.ALL,
               orphanRemoval = true)
    @JsonView(SerializeView.Never.class) // TODO update this to serialize when report is requested
    private List<TestbedTest> testbedTests;

    @ManyToOne
    @JoinColumn(name = "fk_report_id")
    @JsonView(SerializeView.Never.class)
    private Report report;

    public void loadRelations() {
        Hibernate.initialize(getTestbedTests());
    }
}
