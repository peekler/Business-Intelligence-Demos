# System monitoring using InfluxDB, Grafana and Telegraf

## Használat

1. Docker-ben elindítani a 'docker-compose up' paranccsal
1. Telegraf elindítása (adatgyűjtés)
   * Letölhető innen: https://portal.influxdata.com/downloads
   * A használt operációs rendszernek megvelelő verziót töltsuk le, másoljuk mellé a telegraf-demo.conf fájlt
   * Indítas: telegraf --config telegraf-demo.conf
1. Grafana
   * http://localhost:3000 címen érhető el
   * Belépes admin/admin
   * 'Add datasource' linken hozz létre egy újat: InfluxDB a localhost:8086 címen 'direct' kapcsolattal a 'telegraf' nevű adatbázist használva
   * Bal felső ikon menüben 'Dashboards' / 'Import' linken keresztül importáld a 'grafana-dasboard.json' fájt

## Usage

1. Start in Docker with command 'docker-compose up'
1. Start Telegraph (data gathering)
   * Download from: https://portal.influxdata.com/downloads
   * Download for the used operating system system and copz the file 'telegraf-demo.conf' next to it
   * Start with the command: telegraf --config telegraf-demo.conf
1. Grafana
   * Available on address http://localhost:3000
   * User and password: admin/admin
   * On the 'Add datasource' page create a new: InfluxDB on address localhost:8086 with 'direct' connection to database 'telegraf'
   * Using the icon to open the menu in the top left corner use 'Dashboards' / 'Import' to import the file 'grafana-dasboard.json'