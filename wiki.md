## Проблемы мультиадаптерных систем

При иследовании проблем wifi вполне логично использовать более чувствительные внешние адаптеры. При этом может возникнуть проблема с именами сетей.

стандартный вывод
```
user@mashine:~$ nmcli con show

NAME                UUID                                  TYPE      DEVICE 
Mc11_2.4G           be3f567d-8f1a-8f1a-415b-a5f5-93250eaaaa1a  wifi      wlp3s0 
Devolo2.4G          58fhrec6-48f3-4ab3-87d8-e578b17156e8  wifi      --     
```
вывод на мультиадаптерных системах.

```
user@mashine:~$ nmcli con show

NAME                UUID                                  TYPE      DEVICE 
Mc11_2.4G  1        be3f567d-8f1a-415b-a5f5-93250eaaaa1a  wifi      wcard2 
Devolo2.4G          58fhrec6-48f3-4ab3-87d8-e578b17156e8  wifi      --     
```
для избежания возможных конфликтов необходимо выполнить следующие шаги.

1. раскоментировать строку в wifi_test.cfg
```
multicard=1
```
2. отключить внутренний адаптер. 
```
lspci | grep Net		# получить адрес устройства
...
03:00.0 Network controller: Intel Corporation Centrino Ultimate-N 6300 (rev 3e)
```
собственно отключить устройство. работает до перезагрузки.
```
echo 1 | sudo tee /sys/bus/pci/devices/0000\:03\:00.0/remove

```
невзирая на отключение внутреннего адаптера, на некоторых картах может изменятся имя сети.
в случае неполадок при работе скрипта эту проблему следует промониторить в первую очередь.

## Уровни сигнала 
~~~
    до -60 dBm - отличный уровень сигнала;
    от -60 dBm до -70 dBm - хороший уровень сигнала;
    от -70 dBm до -80 dBm - средний уровень сигнала;
    от -80 dBm до - 90 dBm - плохой уровень сигнала;
    от -90 dBm - неудовлетворительный уровень сигнала, который приведет к более быстрому разряду батарей, в том числе к возможным проблемам с передачей данных.
~~~

## Iwconfig. Расшифровка некоторых значений.

**Принят неправильный идентификатор сети (Rx invalid nwid)** Количество пакетов, принятых с различающимися NWID или ESSID. Используется для обнаружения проблем настройки или существующих смежных сетей (на той же частоте).

**Принято неправильное шифрование (Rx invalid crypt)** Количество пакетов, которое оборудование не смогло расшифровать. Это может использоваться для обнаружения неправильных настроек шифрования.

**Принят неправильный фрагмент (Rx invalid frag)** Количество пакетов, для которых оборудование не смогло правильно пересобрать фрагменты уровня канала (в большинстве случаев один был пропущен).

**Превышение повторов передач (Tx excessive retries)** Количество пакетов, которые оборудование не смогло доставить. Большинство протоколов MAC пытаются повторить передачу несколько раз, прежде чем увеличить значение этого счётчика.

**Другие неполадки (Invalid misc)** Другие пакеты, потерянные в соответствующих беспроводных процессах.

**Пропущенные маяки (Missed beacon)** Количество периодических маяков от ячейки или точки доступа, которые были пропущены. Маяки отправляются через равные интервалы для поддержания согласованности сети, ошибка приёма которых обычно указывает на то, что карта покинула область.
