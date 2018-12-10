<!DOCTYPE HTML>
<html lang="ja">
    <head>
        <title>アラーム設定</title>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width,initial-scale=1">
        <link href="./reset.css" rel="stylesheet" />
        <link href="./style.css" rel="stylesheet" />
    </head>
    
    <body>
        <header>
            <img src="./logo@2x.png" class="logo-icn">
        </header>

        <div class="content">
            <div class="alarm-add">
                <h2>アラームを追加</h2>
                <form method="POST" action="index.php">
                <input type="text" name="ADD" value="" class="alarm__text" placeholder="07:00">
                <input type="submit" name="btn" value="追加" class="alarm__btn">
                </form>
            </div> <!--alarm-add-->

            <div class="alarm-delete">
                <h2>アラームを削除</h2>
                <form method="POST" action="index.php">
                <input type="text" name="DELETE" value="" class="alarm__text" placeholder="07:00">
                <input type="submit" name="btn" value="削除" class="alarm__btn">
                </form>
            </div> <!--alarm-delete-->
 
<?php
if ($_SERVER["REQUEST_METHOD"] === "POST") {
    if (!empty($_POST["ADD"])) {
        $post = $_POST["ADD"];
        if (preg_match("/^([0-1][0-9]|[2][0-3]):[0-5][0-9]$/", $post) == 1){
            $alarms = file("txt/alarms.txt", FILE_IGNORE_NEW_LINES | FILE_SKIP_EMPTY_LINES);
            $exist = 0;
            for($i=0; $i<count($alarms); $i++){
                if ($alarms[$i] === $post){
                    $exist = 1;
                    break;
                }
            }
            if ($exist == 1) {
                echo '<span class="action-comment">既に登録されています。</span>';
            } else {
                $file = fopen("txt/alarms.txt", "a");
                fwrite($file, $post."\n");
                fclose($file);
                echo '<span class="action-comment">アラームを設定しました。</span>';
            }
        } else {
            echo '<span class="action-comment">書式が間違っています。</span>';
            echo '<span class="action-comment">アラームを設定したい時刻をHH:MMで指定してください。</span>';
        }
    } else if (!empty($_POST["DELETE"])) {
        $post = $_POST["DELETE"];
        if (preg_match("/^([0-1][0-9]|[2][0-3]):[0-5][0-9]$/", $post) == 1){
            $alarms = file("txt/alarms.txt", FILE_IGNORE_NEW_LINES | FILE_SKIP_EMPTY_LINES);
            $exist = 0;
            for($i=0; $i<count($alarms); $i++){
                if ($alarms[$i] === $post){
                    $exist = 1;
                    $unset_element = $i;
                    break;
                }
            }
            if ($exist == 1) {
                unset($alarms[$unset_element]);
                $alarms = implode("\n", $alarms);
                $file = fopen("txt/alarms.txt", "w");
                fwrite($file, $alarms."\n");
                fclose($file);
                echo '<span class="action-comment">削除しました。</span>';
            } else {
                echo '<span class="action-comment">アラームが追加されていません。</span>';
            } 
        } else {
            echo '<span class="action-comment">書式が間違っています。アラームを設定したい時刻をHH:MMで指定ください。</span>';
        }
    } else {
        echo '<span class="action-comment">入力されていません。</span>';
    }
}
?>

            <div　class="alarm-list">
            <h2>アラームリスト</h2>
            <?php
            $file = fopen("txt/alarms.txt", "r");
            if($file){
                while($line = fgets($file)){
                    echo "<span class=\"alarm-list__time clearfix\">$line</span>";
                }
            }
            fclose($file);
            ?>
            </div> <!--alarm-list-->
        </div> <!--content-->
            
        <nav class="change-bar">
        <ul class="menu">
            <li>
                <a class="inner" href="/index.php">
                    <span class="border">
                        <img src="./alarm-icn.png" class="menu-icn">
                        <span class="menu__text">アラーム</span>
                    </span>
                </a>
            </li>
            <li>
                <a class="inner" href="/bustime.php">
                    <span class="border">
                        <img src="./bus-icn.png" class="menu-icn">
                        <span class="menu__text">バス時刻</span>
                    </span>
                </a>
            </li>
            <li>
                <a class="inner" href="/garbage.php">
                    <span class="border">
                        <img src="./gomi-icn.png" class="menu-icn">
                        <span class="menu__text">ゴミの日</span>
                    </span>
                </a>
            </li>
        </ul>
        </nav> <!--change-bar-->
    </body>
</html>
