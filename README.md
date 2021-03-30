# ComputerV2
Данный проект представляет собой командный интерпретатор. В нем реализована работа с рациональными и комплексными числами, матрицами, а так же функциями. Так же программа способна решать уравнения не выше 2 степени.

## Компиляция
    
    git clone https://github.com/MixFon/ComputerV2.git
    cd ComputerV2/ComputerV2/ComputerV2
    make

Так же программу можно открыть в среде разработке XCode.

    git clone https://github.com/MixFon/ComputerV2.git
    cd ComputerV2/ComputerV2
    open ComputerV2.xcodeproj


## Использование
Программа поддерживает работу с переменными.

### Синтаксис переменой:

    valueName = expression

**valueName** - имя создаваемой переменной. Имя переменной создается без учета регистра переменные varA и vara идентичны.

**expression** - математическое выражение, которое может быть рациональным, комплексным или матричным типом данных.

### Синтаксис функции:

    functionName(variable) = expression
   
**functionName()** - имя функции.

**variable** - имя аргумента функции. Имя аргумента функции не должно совпадать с именем существующей переменной.

**expression** - выражение представленное в виде полинома. Выражение может и не модержать указанной переменной.

### Синтаксис вычисления значения выражения без создания переменной:

    expression = ?
    
**expression** - математическое выражение, которое нужно посчитать.

### Синтаксис решения уравнения:

    functionName(variable) = expression ?

**functionName()** - имя существующей функции.

**expression** - значение функции для решения уравнения. Данное выражение может быть только рационального типа.



### Работа с рациональными числами
