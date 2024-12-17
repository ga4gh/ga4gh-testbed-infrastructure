package org.ga4gh.testbed.api.model;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;
import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
import javax.persistence.OneToOne;
import javax.persistence.Table;
import com.fasterxml.jackson.annotation.JsonFormat;
import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.annotation.JsonManagedReference;
import com.fasterxml.jackson.annotation.JsonView;
import com.fasterxml.jackson.databind.PropertyNamingStrategies;
import com.fasterxml.jackson.databind.annotation.JsonDeserialize;
import com.fasterxml.jackson.databind.annotation.JsonNaming;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;
import com.fasterxml.jackson.datatype.jsr310.deser.LocalDateTimeDeserializer;
import com.fasterxml.jackson.datatype.jsr310.ser.LocalDateTimeSerializer;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.vladmihalcea.hibernate.type.json.JsonType;
import org.ga4gh.starterkit.common.constant.DateTimeConstants;
import org.ga4gh.starterkit.common.hibernate.HibernateEntity;
import org.ga4gh.testbed.api.utils.SerializeView;
import org.hibernate.Hibernate;
import org.hibernate.annotations.Type;
import org.hibernate.annotations.TypeDef;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Entity
@Table(name = "report")
@Setter
@Getter
@NoArgsConstructor
@JsonInclude(JsonInclude.Include.NON_EMPTY)
@JsonNaming(PropertyNamingStrategies.SnakeCaseStrategy.class)
@TypeDef(name = "json", typeClass = JsonType.class)
public class Report implements HibernateEntity<String> {

    @Id
    @Column(name = "id", updatable = false, nullable = false)
    @JsonView(SerializeView.Always.class)
    private String id;

    @Column(name = "schema_name", nullable = false)
    @JsonView(SerializeView.Always.class)
    private String schemaName;

    @Column(name = "schema_version", nullable = false)
    @JsonView(SerializeView.Always.class)
    private String schemaVersion;

    @Type(type = "json")
    @Column(name = "input_parameters", columnDefinition = "json", nullable = false)
    @JsonView(SerializeView.Always.class)
    private Map<String, String> inputParameters;

    @Column(name = "start_time", nullable = false)
    @JsonDeserialize(using = LocalDateTimeDeserializer.class)
    @JsonSerialize(using = LocalDateTimeSerializer.class)
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = DateTimeConstants.DATE_FORMAT)
    @JsonView(SerializeView.Always.class)
    private LocalDateTime startTime;

    @Column(name = "end_time", nullable = false)
    @JsonDeserialize(using = LocalDateTimeDeserializer.class)
    @JsonSerialize(using = LocalDateTimeSerializer.class)
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = DateTimeConstants.DATE_FORMAT)
    @JsonView(SerializeView.Always.class)
    private LocalDateTime endTime;

    @Column(name = "status", nullable = false)
    @JsonView(SerializeView.Always.class)
    private Status status;

    @OneToOne(cascade = CascadeType.ALL, orphanRemoval = true)
    @JoinColumn(name = "fk_summary_id", referencedColumnName = "id")
    @JsonView(SerializeView.ReportSimple.class)
    private Summary summary;

    @OneToMany(mappedBy = "report", fetch = FetchType.EAGER, cascade = CascadeType.ALL, orphanRemoval = true)
    @JsonManagedReference
    @JsonView(SerializeView.ReportSimple.class)
    private List<Phase> phases;

    @ManyToOne(
        fetch = FetchType.LAZY,
        cascade = {CascadeType.PERSIST, CascadeType.MERGE,
                   CascadeType.DETACH, CascadeType.REFRESH}
    )
    @JoinColumn(name = "fk_report_series_id")
    @JsonView(SerializeView.ReportFull.class)
    private ReportSeries reportSeries;

    @ManyToOne(cascade = CascadeType.ALL)
    @JoinColumn(name = "testbed", referencedColumnName = "id")
    @JsonView(SerializeView.ReportSimple.class)
    private Testbed testbed;

    @JsonProperty("private")
    @Column(name = "private", nullable = false)
    @JsonView(SerializeView.Always.class)
    private Boolean isPrivate;

    public void loadRelations() {
        Hibernate.initialize(getPhases());
    }
}
