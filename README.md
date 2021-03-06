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
    
    ./computer
    > varA = 2
    > 2
    > varB = 2 * (4 + varA + 3)
    > 18
    > varC = 2 * varB
    > 36
    > varD = 2 * (2 + 4 * varC - 4 / 3)
    > 289.333
    > varE = 2 + 4 *2 - 5 %4 + 2 * (4 + 5)
    > 27
    > ls
    > Variables:
    > vara = 2
    > varb = 18
    > varc = 36
    > vard = 289.333
    > vare = 27

### Работа с комплексными числами

    ./computer
    > imA = i
    > 0+1i
    > imB = (imA + 3)^2
    > 8+6i
    > imC = imB * imA
    > -6+8i
    > imD = imC^(5 - 4)
    > -6+8i
    > imD = imD / 11
    > -0.545455+0.727273i
    > imE = imD - imA * imB
    > 5.45455-7.27273i
    > ls
    > Variables:
    > ima = 0+1i
    > imb = 8+6i
    > imc = -6+8i
    > imd = -0.545455+0.727273i
    > ime = 5.45455-7.27273i

### Работа с матрицами

    ./computer
    > matA = [[2,3,4];[5,6,7];[8,9,0]]
    > [2, 3, 4]
    > [5, 6, 7]
    > [8, 9, 0]
    > matB = [[-1];[-2];[-3]]
    > [-1]
    > [-2]
    > [-3]
    > matC = matA ** matB
    > [-20]
    > [-38]
    > [-26]
    > matD = [[1,2,3];[1,3,4];[4,5,6]]
    > [1, 2, 3]
    > [1, 3, 4]
    > [4, 5, 6]
    > matC = matD * matA
    > [2, 6, 12]
    > [5, 18, 28]
    > [32, 45, 0]
    > matC = matC - 3
    > [-1, 3, 9]
    > [2, 15, 25]
    > [29, 42, -3]
    > ls
    > Variables:
    > mata =
    > [2, 3, 4]
    > [5, 6, 7]
    > [8, 9, 0]
    > matb =
    > [-1]
    > [-2]
    > [-3]
    > matd =
    > [1, 2, 3]
    > [1, 3, 4]
    > [4, 5, 6]
    > matc =
    > [-1, 3, 9]
    > [2, 15, 25]
    > [29, 42, -3]

### Работа с функциями

### Приведение к полиному стандартного вида и решение уравнения.

    ./computer
    > f(x) = (x^2 + 3*x)^2
    > f(x) = 0 ?
    > 1X^4+6X^3+9X^2
    > Reduced form: 1X^4+6X^3+9X^2=0
    > Polynomial degree: 4
    > The polynomial degree is strictly greater than 2, I can't solve.
    > c(x) = 4*x^2 + 5*x-5
    > 4*x^2+5*x-5
    > c(x) = 0 ?
    > 4X^2+5X-5
    > Reduced form: 4X^2+5X-5=0
    > Polynomial degree: 2
    > Discriminant is strictly positive, the two solutions are:
    > -1.90587
    > 0.655869
    
### Вычисление значения функции
    > g(x) = (4.4*x^3 - 2*5.5*x^2 + 3*x -3)*(7.5*x^2 - 6/4*x + 10%3)
    > (4.4*x^3-2*5.5*x^2+3*x-3)*(7.5*x^2-6/4*x+10%3)
    > g(4 + 3/4) = ?
    > 38264.9
    > ls
    > Functions:
    > f(x) = (x^2+3*x)^2
    > r(x) = x^2-5x+4
    > g(x) = (4.4*x^3-2*5.5*x^2+3*x-3)*(7.5*x^2-6/4*x+10%3)
    > c(x) = 4*x^2+5*x-5
