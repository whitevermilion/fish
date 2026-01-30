# Fish Shell 数学计算指南

## 1. **内置数学功能**

### 基础算术运算

```fish
# 使用 math 命令
math "2 + 2"               # → 4
math "10 - 5"              # → 5
math "3 * 4"               # → 12
math "15 / 3"              # → 5
math "2 ^ 8"               # → 256（幂运算）
math "sqrt(16)"            # → 4
math "2 * (3 + 4)"         # → 14（支持括号）
```

### 变量计算

```fish
set x 10
set y 3

math "$x + $y"             # → 13
math "$x * $y"             # → 30
math "$x / $y"             # → 3（整数除法）
math "$x % $y"             # → 1（取模）
```

### 浮点数计算（需要指定精度）

```fish
# 使用 bc 命令处理浮点数
echo "scale=3; 10/3" | bc  # → 3.333（scale指定小数位数）
echo "5.5 + 2.3" | bc      # → 7.8
```

## 2. **常用数学命令**

### 使用 `bc` - 高精度计算器

```fish
# 基础计算
echo "5 + 3" | bc          # → 8

# 浮点数计算
echo "scale=2; 10/3" | bc  # → 3.33

# 科学计数法
echo "2.5 * 10^3" | bc -l  # → 2500

# 三角函数（需要-l加载数学库）
echo "s(3.14159)" | bc -l  # → 正弦函数
echo "c(0)" | bc -l        # → 余弦函数
echo "a(1)" | bc -l        # → 反正切

# 平方根
echo "sqrt(16)" | bc       # → 4
```

### 使用 `dc` - 逆波兰式计算器

```fish
echo "5 3 + p" | dc        # → 8（5+3）
echo "10 2 / p" | dc       # → 5（10/2）
echo "2 8 ^ p" | dc        # → 256（2^8）
```

### 使用 `awk` 进行数学运算

```fish
# 简单计算
awk 'BEGIN {print 2+2}'    # → 4
awk 'BEGIN {print 10/3}'   # → 3.33333

# 使用变量
awk -v x=5 -v y=3 'BEGIN {print x*y}'  # → 15
```

### 使用 `expr`（兼容性考虑）

```fish
# 整数运算
expr 2 + 2                 # → 4
expr 10 \* 3               # → 30（注意*需要转义）
```

## 3. **实用函数库**

### 创建数学函数（添加到 `~/.config/fish/config.fish`）

```fish
# 计算器函数
function calc
    math "$argv"
end

# 浮点数计算
function fcalc
    echo "$argv" | bc -l
end

# 单位转换
function convert_units
    set -l value $argv[1]
    set -l from $argv[2]
    set -l to $argv[3]

    # 温度转换示例
    if test "$from" = "c" -a "$to" = "f"
        math "($value * 9/5) + 32"
    else if test "$from" = "f" -a "$to" = "c"
        math "($value - 32) * 5/9"
    else
        echo "未知转换"
    end
end

# 平均值计算
function avg
    set -l sum 0
    set -l count (count $argv)

    for num in $argv
        set sum (math "$sum + $num")
    end

    math "$sum / $count"
end
```

## 4. **常见数学操作示例**

### 进制转换

```fish
# 十进制转其他进制
echo "obase=16; 255" | bc      # → FF（十六进制）
echo "obase=2; 10" | bc        # → 1010（二进制）
echo "obase=8; 64" | bc        # → 100（八进制）

# 其他进制转十进制
echo "ibase=16; FF" | bc       # → 255
echo "ibase=2; 1010" | bc      # → 10
```

### 三角函数计算

```fish
# 角度转弧度计算
echo "scale=4; 45 * (3.14159/180)" | bc -l  # → 0.7854

# 正弦值
echo "s(0.7854)" | bc -l                    # → 0.7071

# 余弦值
echo "c(0.7854)" | bc -l                    # → 0.7071
```

### 统计计算

```fish
# 最大值
echo "5 8 3 12 7" | tr ' ' '\n' | sort -n | tail -1  # → 12

# 最小值
echo "5 8 3 12 7" | tr ' ' '\n' | sort -n | head -1  # → 3

# 求和
echo "1 2 3 4 5" | tr ' ' '+' | bc                   # → 15

# 平均数
echo "1 2 3 4 5" | tr ' ' '\n' | awk '{sum+=$1} END{print sum/NR}'  # → 3
```

## 5. **快捷别名（添加到 config.fish）**

```fish
# 数学计算别名
alias m='math'
alias mc='echo'  # 配合管道使用
alias bcl='bc -l'
alias calc='bc -l <<<'

# 快速计算
alias sum='paste -sd+ | bc'
alias avg='paste -sd+ | bc -l | awk "{print \$1 / (NF-1)}"'
```

## 6. **交互式计算器**

### 创建交互式计算器脚本

```fish
function calculator
    echo "Fish 计算器 (输入 'q' 退出)"

    while true
        read -l -P ">>> " input

        if test "$input" = "q" -o "$input" = "quit" -o "$input" = "exit"
            break
        else if test -n "$input"
            math "$input" 2>/dev/null
            if test $status -ne 0
                echo "无效表达式"
            end
        end
    end
end
```

### 使用外部计算器

```fish
# 安装和启动交互式计算器
# bc 交互模式
bc -l

# python 计算器
python -ic "from math import *"

# 安装 qalc（单位转换强大）
# yay -S libqalculate
qalc
```

## 7. **实用技巧**

### 管道计算

```fish
# 计算文件夹大小总和（MB）
du -sm * | awk '{sum+=$1} END{print sum " MB"}'

# 计算文件数量
ls | wc -l | math

# 计算CPU使用率平均值
mpstat 1 5 | tail -5 | awk '{sum+=$12} END{print 100-sum/NR "% idle"}'
```

### 表达式求值

```fish
# 直接计算数学表达式
set result (math "2 + 3 * 4")
echo $result  # → 14

# 使用变量
set x 5
set y 3
set area (math "$x * $y")
echo "面积: $area"
```

## 8. **故障排除**

### 常见问题

1. **浮点数精度问题**

   ```fish
   # 使用 bc 而不是 math
   echo "scale=10; 1/3" | bc  # → 0.3333333333
   ```

2. **表达式包含特殊字符**

   ```fish
   # 使用引号
   math "2 * (3 + 4)"
   math 'sqrt(16)'
   ```

3. **需要更高级功能**
   ```fish
   # 安装增强工具
   yay -S calc   # 高级命令行计算器
   yay -S qalc   # 单位转换计算器
   ```

### 调试技巧

```fish
# 检查表达式
echo "表达式: 2 + 2"
math "2 + 2"

# 查看变量值
set x 5
echo "x = $x"
math "$x * 2"
```

---

**快速参考卡**

```
基础：      math "2+3"              # → 5
浮点数：    echo "10/3" | bc -l     # → 3.33333
函数：      math "sqrt(16)"         # → 4
变量：      math "$x + $y"
进制转换：  echo "obase=16; 255" | bc  # → FF
交互模式：  bc -l 或 calculator 函数
```

建议将常用函数添加到 `~/.config/fish/config.fish` 中，方便日常使用。
