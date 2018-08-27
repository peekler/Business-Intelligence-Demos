# Elasticsearch, Logstash, Kibana

## Használat

1. Indítsd el Docker segítségével a 'docker-compose up' paranccsal
1. A Kibana a http://localhost:5601 címen lesz elérhető
1. Az első oldalon ("Configure an index pattern") "Create"
1. A fenti menüben "Saved Objects" / "Import" alatt betölteni a kibana-export.json fájlt
1. Bal oldali menüben "Dashboard" linken válasszuk a "procdump dashboard"-ot

## Usage

1. Start the system using Docker by typing the 'docker-compose up' command
1. Kibana will be available at http://localhost:5601
1. On the first page ("Configure an index pattern") click "Create"
1. In the top menu use "Saved Objects" / "Import" to import file kibana-export.json
1. In the left menu under "Dashboard" open the dashboars with name "procdump dashboard"