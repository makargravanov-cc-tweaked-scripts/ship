# Ship — установка через wget (CC:Tweaked)

Репозиторий: `https://github.com/makargravanov-cc-tweaked-scripts/ship`

Файлы лежат так (имена в URL = имена папок):

- `fc/startup.lua` — центральный комп (FC, автозапуск)
- `ecu/startup.lua` — общий код для всех 16 ECU
- `ecu-config/<ID>/ecu.json` — конфиг под каждый ECU, где `<ID>` = `FL-up`, `FL-fwd`, `FL-aft`, `FL-side`, `FR-...`, `BL-...`, `BR-...`

Скачивание в CC:Tweaked делается утилитой `wget`:

## FC (центральный комп, 1 шт)

```
wget https://raw.githubusercontent.com/makargravanov-cc-tweaked-scripts/ship/main/fc/startup.lua startup.lua
reboot
```

## ECU (16 шт, на каждом моторе — свой ID)

Заменить `<ID>` на свой, например `FL-up`:

```
wget https://raw.githubusercontent.com/makargravanov-cc-tweaked-scripts/ship/main/ecu/startup.lua startup.lua
wget https://raw.githubusercontent.com/makargravanov-cc-tweaked-scripts/ship/main/ecu-config/<ID>/ecu.json ecu.json
reboot
```

Примеры готовых пар команд:

```
wget https://raw.githubusercontent.com/makargravanov-cc-tweaked-scripts/ship/main/ecu/startup.lua startup.lua
wget https://raw.githubusercontent.com/makargravanov-cc-tweaked-scripts/ship/main/ecu-config/FL-up/ecu.json ecu.json
```

```
wget https://raw.githubusercontent.com/makargravanov-cc-tweaked-scripts/ship/main/ecu/startup.lua startup.lua
wget https://raw.githubusercontent.com/makargravanov-cc-tweaked-scripts/ship/main/ecu-config/FL-fwd/ecu.json ecu.json
```

```
wget https://raw.githubusercontent.com/makargravanov-cc-tweaked-scripts/ship/main/ecu/startup.lua startup.lua
wget https://raw.githubusercontent.com/makargravanov-cc-tweaked-scripts/ship/main/ecu-config/FL-aft/ecu.json ecu.json
```

```
wget https://raw.githubusercontent.com/makargravanov-cc-tweaked-scripts/ship/main/ecu/startup.lua startup.lua
wget https://raw.githubusercontent.com/makargravanov-cc-tweaked-scripts/ship/main/ecu-config/FL-side/ecu.json ecu.json
```

```
wget https://raw.githubusercontent.com/makargravanov-cc-tweaked-scripts/ship/main/ecu/startup.lua startup.lua
wget https://raw.githubusercontent.com/makargravanov-cc-tweaked-scripts/ship/main/ecu-config/FR-up/ecu.json ecu.json
```

```
wget https://raw.githubusercontent.com/makargravanov-cc-tweaked-scripts/ship/main/ecu/startup.lua startup.lua
wget https://raw.githubusercontent.com/makargravanov-cc-tweaked-scripts/ship/main/ecu-config/FR-fwd/ecu.json ecu.json
```

```
wget https://raw.githubusercontent.com/makargravanov-cc-tweaked-scripts/ship/main/ecu/startup.lua startup.lua
wget https://raw.githubusercontent.com/makargravanov-cc-tweaked-scripts/ship/main/ecu-config/FR-aft/ecu.json ecu.json
```

```
wget https://raw.githubusercontent.com/makargravanov-cc-tweaked-scripts/ship/main/ecu/startup.lua startup.lua
wget https://raw.githubusercontent.com/makargravanov-cc-tweaked-scripts/ship/main/ecu-config/FR-side/ecu.json ecu.json
```

```
wget https://raw.githubusercontent.com/makargravanov-cc-tweaked-scripts/ship/main/ecu/startup.lua startup.lua
wget https://raw.githubusercontent.com/makargravanov-cc-tweaked-scripts/ship/main/ecu-config/BL-up/ecu.json ecu.json
```

```
wget https://raw.githubusercontent.com/makargravanov-cc-tweaked-scripts/ship/main/ecu/startup.lua startup.lua
wget https://raw.githubusercontent.com/makargravanov-cc-tweaked-scripts/ship/main/ecu-config/BL-fwd/ecu.json ecu.json
```

```
wget https://raw.githubusercontent.com/makargravanov-cc-tweaked-scripts/ship/main/ecu/startup.lua startup.lua
wget https://raw.githubusercontent.com/makargravanov-cc-tweaked-scripts/ship/main/ecu-config/BL-aft/ecu.json ecu.json
```

```
wget https://raw.githubusercontent.com/makargravanov-cc-tweaked-scripts/ship/main/ecu/startup.lua startup.lua
wget https://raw.githubusercontent.com/makargravanov-cc-tweaked-scripts/ship/main/ecu-config/BL-side/ecu.json ecu.json
```

```
wget https://raw.githubusercontent.com/makargravanov-cc-tweaked-scripts/ship/main/ecu/startup.lua startup.lua
wget https://raw.githubusercontent.com/makargravanov-cc-tweaked-scripts/ship/main/ecu-config/BR-up/ecu.json ecu.json
```

```
wget https://raw.githubusercontent.com/makargravanov-cc-tweaked-scripts/ship/main/ecu/startup.lua startup.lua
wget https://raw.githubusercontent.com/makargravanov-cc-tweaked-scripts/ship/main/ecu-config/BR-fwd/ecu.json ecu.json
```

```
wget https://raw.githubusercontent.com/makargravanov-cc-tweaked-scripts/ship/main/ecu/startup.lua startup.lua
wget https://raw.githubusercontent.com/makargravanov-cc-tweaked-scripts/ship/main/ecu-config/BR-aft/ecu.json ecu.json
```

```
wget https://raw.githubusercontent.com/makargravanov-cc-tweaked-scripts/ship/main/ecu/startup.lua startup.lua
wget https://raw.githubusercontent.com/makargravanov-cc-tweaked-scripts/ship/main/ecu-config/BR-side/ecu.json ecu.json
```

## Команды пилота (на FC после reboot)

```
hold
hover 400
goto 100 400 -200
route 100 400 -200 300 400 500
status
abort
```
