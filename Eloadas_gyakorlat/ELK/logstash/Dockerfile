FROM logstash:5
ADD pipeline/procdump-sample.conf /usr/share/logstash/pipeline/procdump-sample.conf
ADD sampledata/procdump.csv /usr/share/sampledata/procdump.csv
CMD ["-f", "/usr/share/logstash/pipeline/procdump-sample.conf"]