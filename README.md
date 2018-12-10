# Otasuke Mezamashi
(私のために)
Raspberry pi 向けにIoT目覚まし機能を追加するパッケージです。

アラーム、バス発車時刻、ゴミの種類を登録することができます。

アラームを登録すると、登録した時刻に音楽が鳴り、
人感センサーが人を検知するまで音楽を鳴らします。

その後、東京の天気予報を読み上げます。

バス発車時刻を登録すると、
アラームが止まった後に、直近3件のバス発車時刻を読み上げます。

ゴミを登録しておくと、
当日の曜日に対応したゴミの種類を読み上げてくれます。

PHPの登録ページや各スクリプトの関連の弱さ？など
不出来な部分が相当多いので、余力があれば、いつか作り直します。

アラーム音楽は「~/otasuke/wav/」に入れて、
「get_human.py」の「play_music」で指定してください。
