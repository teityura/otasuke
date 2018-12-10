<!DOCTYPE HTML>
<html lang="ja">
<head>
  <title>ゴミの種類設定</title>
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
    <h2>ゴミの種類を追加</h2>
    <form method="POST" action="garbage.php">
 <select name="youbi">
    <option >▼曜日選択してください</option>
    <option value="日:">日</option>
    <option value="月:">月</option>
    <option value="火:">火</option>
    <option value="水:">水</option>
    <option value="木:">木</option>
    <option value="金:">金</option>
    <option value="土:">土</option>
  </select>
      <input type="text" name="ADD" value="" class="alarm__text" placeholder="燃えるゴミ">
      <input type="submit" name="btn" value="追加" class="alarm__btn">
    </form>

</div> <!--alarm-add-->

<div class="alarm-delete">

      <h2>ゴミの種類を削除</h2>
      <form method="POST" action="garbage.php">
     <select name="youbi">
     <option >▼曜日選択してください</option>
     <option value="日:">日</option>
     <option value="月:">月</option>
     <option value="火:">火</option>
     <option value="水:">水</option>
     <option value="木:">木</option>
     <option value="金:">金</option>
     <option value="土:">土</option>
   </select>
      <input type="text" name="DELETE" value="" class="alarm__text" placeholder="燃えるゴミ">
      <input type="submit" name="btn" value="削除" class="alarm__btn">
      </form>

</div> <!--alarm-delete-->



<?php
$select = $_REQUEST["youbi"];
if($_SERVER["REQUEST_METHOD"] === "POST"){
  if(!empty($_POST["ADD"])){
    $post = $_POST["ADD"];
    if (preg_match("/^[ぁ-んァ-ヶー一-龠]+$/u",$post)==1){
      $garbage = file("txt/garbage.txt", FILE_IGNORE_NEW_LINES | FILE_SKIP_EMPTY_LINES);
      $exist = 0;
      for($i=0; $i<count($garbage); $i++){
        if($garbage[$i] === $post){
          $exist = 1;
          break;
        }
      }
      if($exist == 1){
        echo '<span class="action-comment">既に登録されています。</span>';
      }else{
        $file = fopen("txt/garbage.txt", "a");
        fwrite($file, $select.$post."\n");
        fclose($file);
        echo '<span class="action-comment">ゴミの種類を設定しました。</span>';
      }

    }else{
      echo '<span class="action-comment">書式が間違っています。</span>';
      echo '<span class="action-comment">ゴミの種類を全角で指定してください。</span>';
    }
  }elseif(!empty($_POST["DELETE"])){
    $post = $_POST["DELETE"];
    if (preg_match("/^[ぁ-んァ-ヶー一-龠]+$/u",$post)==1){
      $garbage = file("txt/garbage.txt", FILE_IGNORE_NEW_LINES | FILE_SKIP_EMPTY_LINES);
      $exist = 0;
      for($i=0; $i<count($garbage); $i++){
        if($garbage[$i] === $select.$post){
          $exist = 1;
          $unset_element = $i;
          break;
        }
      }
      if($exist == 1){
        unset($garbage[$unset_element]);
        $garbage = implode("\n", $garbage);
        $file = fopen("txt/garbage.txt", "w");
        fwrite($file, $garbage."\n");
        fclose($file);
        echo '<span class="action-comment">削除しました。</span>';
      }else{
        echo '<span class="action-comment">ゴミの種類が追加されていません。</span>';
      }

    }else{
      echo '<span class="action-comment">書式が間違っています。ゴミの種類を全角で指定してください。</span>';
    }
  }else{
    echo '<span class="action-comment">入力されていません。</span>';
  }
}
?>


<div　class="alarm-list">

  <h2>ゴミの日リスト</h2>
  <?php
  $file = fopen("txt/garbage.txt", "r");
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
</nav>

</body>
</html>
