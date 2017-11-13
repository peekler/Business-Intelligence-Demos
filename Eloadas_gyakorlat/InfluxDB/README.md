# Rendszer monitorozas InfluxDB, Grafana, Telegraf hasznalataval

## Docker image
Elinditas: 'docker-compose up'

## Telegraf
1. Letolheto innen: https://portal.influxdata.com/downloads
1. Adott operacis rendszernek megvelelo verziot toltsuk le, masoljuk melle a telegraf-demo.conf fajlt
1. Inditas: telegraf --config telegraf-demo.conf

## Grafana
1. http://localhost:3000
1. Belepes admin/admin
1. Add datasource linken InfluxDB-hey kapcsoldotva a localhost:8086 cimen direct kapcsolattal a telegraf nevu adatbazishoz
1. Bel felso ikon menuben Dashboards/Import linken keresztul impoetaljuk a grafana-dasboard.json fajt