# Домашнее задание по теме: "Основы Golang"

## Задача 1. Установите golang.
1. Воспользуйтесь инструкций с официального сайта: [https://golang.org/](https://golang.org/).
2. Так же для тестирования кода можно использовать песочницу: [https://play.golang.org/](https://play.golang.org/).

## Задача 2. Знакомство с gotour.
У Golang есть обучающая интерактивная консоль [https://tour.golang.org/](https://tour.golang.org/). 
Рекомендуется изучить максимальное количество примеров. В консоли уже написан необходимый код, 
осталось только с ним ознакомиться и поэкспериментировать как написано в инструкции в левой части экрана.  

## Задача 3. Написание кода. 
Цель этого задания закрепить знания о базовом синтаксисе языка. Можно использовать редактор кода 
на своем компьютере, либо использовать песочницу: [https://play.golang.org/](https://play.golang.org/).

1. Напишите программу для перевода метров в футы (1 фут = 0.3048 метр). Можно запросить исходные данные 
у пользователя, а можно статически задать в коде.
    Для взаимодействия с пользователем можно использовать функцию `Scanf`:
    ```
    package main
    
    import "fmt"
    
    func main() {
        fmt.Print("Enter a number: ")
        var input float64
        fmt.Scanf("%f", &input)
    
        output := input * 2
    
        fmt.Println(output)    
    }
    ```

    ### Результат

    #### Конфертация метров в футы

    ```golang
    package main

    import "fmt"

    func Converting(x float64) float64 {
        return x * 3.28084
    }

    func main() {
        fmt.Printf("Введите количество метров: ")
        var input float64
        fmt.Scanf("%f", &input)
        output := Converting(input)
        fmt.Printf("Количество футов в %g метрах: %g\n", input, output)
    }
    ```

    ```shell
    # go build
    # ./main 
    Введите количество метров: 5
    Количество футов в 5 метрах: 16.4042
    ```

    #### Тест

    ```golang
    package main

    import "testing"

    func TestConverting(t *testing.T) {
        want := 9.84252
        got := Converting(3)
        if got != want {
            t.Errorf("Получено: %g, требуется %g", got, want)
        }
    }
    ```

    ```shell
    go test -v *.go
    === RUN   TestConverting
    --- PASS: TestConverting (0.00s)
    PASS
    ok      command-line-arguments  0.015s
    ```

1. Напишите программу, которая найдет наименьший элемент в любом заданном списке, например:
    ```
    x := []int{48,96,86,68,57,82,63,70,37,34,83,27,19,97,9,17,}
    ```

    ### Результат

    ```golang
    package main

    import (
        "fmt"
        "sort"
    )

    func MinEl(array []int) int {
        sort.Ints(array)
        return array[0]
    }

    func main() {
        x := []int{48, 96, 86, 68, 57, 82, 63, 70, 37, 34, 83, 27, 19, 97, 9, 17}
        min := MinEl(x)
        fmt.Printf("Наименьший элемент в списке: %d.\n", min)
    }
    ```

    ```shell
    Наименьший элемент в списке: 9.
    ```

    #### Тест

    ```golang
    package main

    import "testing"

    func TestMinEl(t *testing.T) {
        want := 3
        got := MinEl([]int{9, 6, 3})
        if got != want {
            t.Errorf("Получено: %d, требуется %d", got, want)
        }
    }
    ```

    ```shell
    go test -v *.go
    === RUN   TestMinEl
    --- PASS: TestMinEl (0.00s)
    PASS
    ok      command-line-arguments  0.073s
    ```

1. Напишите программу, которая выводит числа от 1 до 100, которые делятся на 3. То есть `(3, 6, 9, …)`.

    ### Результат

    ```golang
    package main

    import "fmt"

    func Division(x int) int{
        if x % 3 == 0 {
            fmt.Printf("Число %d делится на 3 без остатка.\n", x)
            
        }
        return x % 3
    }

    func main() {
        for i := 1; i <= 100; i++ {
            Division(i)
        }
    }
    ```

    ```shell
    Число 3 делится на 3 без остатка.
    Число 6 делится на 3 без остатка.
    Число 9 делится на 3 без остатка.
    Число 12 делится на 3 без остатка.
    Число 15 делится на 3 без остатка.
    ...
    Число 87 делится на 3 без остатка.
    Число 90 делится на 3 без остатка.
    Число 93 делится на 3 без остатка.
    Число 96 делится на 3 без остатка.
    Число 99 делится на 3 без остатка.
    ```

    #### Тест

    ```golang
    package main

    import "testing"

    func TestDivison(t *testing.T) {
        want := 0
        got := Division(3)
        if got != want {
            t.Errorf("Получено: %d, требуется %d", got, want)
        }
    }
    ```

    ```shell
    go test -v *.go
    === RUN   TestDivison
    Число 3 делится на 3 без остатка.
    --- PASS: TestDivison (0.00s)
    PASS
    ok      command-line-arguments  0.037s
    ```

В виде решения ссылку на код или сам код. 

## Задача 4. Протестировать код (не обязательно).

Создайте тесты для функций из предыдущего задания. 

### Результат

Тесты созданы в каждом из пунктов.
