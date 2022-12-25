# 李さんの日本語入力方法/小李的日本语输入法(rime_pinyin_jap)
一個Rime“日本語”輸入方案，完全忽略音読訓読，使用漢語拼音录入日語漢字字形，使用羅馬音録入仮名，輸入大写字母可以録入片仮名，使用x前导可以输入小写仮名。  
  
使用客制化文件的方式，在[【融合拼音】](https://github.com/tumuyan/rime-pinyin-simp)方案的基礎上，中引入了由[【poly日文】](https://github.com/biopolyhedron/rime-jap-poly) 修改而来的【Japanese Poly Nano】  
与融合拼音（rime_pinyin)共用漢語詞庫，可以使用融合拼音的詞庫覆蓋本方案的文件。
適用於基本不懂日語並且也無意深入学習，但是又有一定日語書写需求的人。(没错,這個命名正是对学习新标日小李赴日的neta)  

version<=1.1的版本中，保留了原有項目的文件結構，通過引用、patch機制実現修改効果。1.1之後縮減文件数量並且不再使用patch機制。

## 使用方法
1. [下载文件](https://github.com/tumuyan/rime-pinyin-jap/archive/master.zip)、解压文件并复制到`Rime用户文件夹`内。用户文件夹位置：  
    * 【中州韻】 ~/.config/ibus/rime/ （0.9.1 以下版本爲 ~/.ibus/rime/）
    * 【小狼毫】 %APPDATA%\Rime
    * 【鼠鬚管】 ~/Library/Rime/
2. 剪切opencc目録到`程序文件夾`内。路径位置：
    * 【小狼毫】 C:\Program Files (x86)\Rime\weasel-0.14.3\data
3. 启用【李さんの日本語】和【Japanese Poly Nano】方案。
4. 打开 Rime 方案选单（输入状态下按Ctrl + ~），切换至【李さんの日本語】即可。

## 文件组成
[【融合拼音】](https://github.com/tumuyan/rime-pinyin-simp)   
* `pinyin_jap.schema` ：融合拼音方案文件修改而来，進一歩溯源実際就是袖珍簡化字方案文件。  
* `pinyin_jap.dict.yaml` ：融合拼音主詞庫修改而来，去除了一部分詞庫引用。
* `pinyin_simp_base.dict.yaml`：融合拼音詞庫原様復制，現代漢語詞表。
* `pinyin_simp_chengyu.dict.yaml`：融合拼音詞庫原様復制，成語俗語詞表  
* 具体情況不一一説明。詳見融合拼音的readme。

[【poly日文】](https://github.com/biopolyhedron/rime-jap-poly)  
- `jap_poly_nano.dict.yaml`：poly日文詞庫。有修改  
- `jap_poly_nano.schema.yaml`：poly方案文件。有修改  

【lua沪鏡】  
* `rime.lua` 【融合拼音】和本方案共用的lua増強沪鏡。如果其他方案也使用了lua，請打開文件並復制内容粘貼到原rime.lua文件中。
  
【編碼沪鏡】（需放置到軟件安装目録的opencc目録） 
* `rizi` 簡体中文転日語新字形，TRIME群友提供，目測由 https://github.com/BYVoid/OpenCC/blob/master/data/dictionary/JPVariants.txt 転換而来。
