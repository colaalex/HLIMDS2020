# Определение движения
К устройству подключены пироэлектрический датчик, светодиод и камера. Когда пироэлектрический датчик срабатывает (рядом было движение), включается камера, обводит в рамку человека, если нейронная сеть определила, что это человек, а если было движение человека, выделяет область движения красной рамкой.
Для работы программы к стандартному дистрибутиву python3 для Raspberry Pi необходимы следующие пакеты:
* opencv-python
* opencv-contrib-python
* libqt4-test
* libqtgui4

## Установка:
`sudo apt install libqtgui4 libqt4-test`

`sudo pip3 install opencv-python opencv-contrib-python`

## Запуск
Из дериктории с файлом detector.py

`python3 detector.py`

## Содержимое директории
Помимо файла `detector.py` в директории есть следующие файлы:
* `frozen_inference_graph.pb` - предобученная модель 
* `mobilenet_config.pbtxt` - конфигурационный файл 
* `sensor505.py` - код с запуском видеопотока по срабатыванию датчика без нейронной сети

Подробнее о файлах с предобученной моделью и конфигурации можно прочитать по ссылке https://github.com/opencv/opencv/wiki/TensorFlow-Object-Detection-API#use-existing-config-file-for-your-model

## Принцип работы
Импорт необходимых библиотек:
```python3
import cv2 as cv  # работа с видео и обнаружение движения
import RPi.GPIO as GPIO  # работа с пинами на плате
```

В переменной SENS указывается номер пина на плате, к которой подключен датчик:
```python
SENS = 23
```

На основании предобученной модели и конфигурационного файла загружается нейронная сеть:
```python3
model = 'frozen_inference_graph.pb'
config = 'mobilenet_config.pbtxt'
net = cv.dnn.readNetFromTensorflow(model, config)  # сеть на обученной модели
```

Получаем видеопоток:
```python3
cap = cv.VideoCapture(0)  # получаем кадры с камеры
# first_frame и prev_frame используются для сравнения кадров
first_frame = None
prev_frame = None

# в данном алгоритме идет сравнение не каждого кадра
# (если параметр freq не равен 1), а с преиодичностью раз в
# freq кадров
count = 0
freq = 1
```

Настраиваем получение сигнала с пина SENS:
```python3
GPIO.setmode(GPIO.BCM)
GPIO.setup(SENS, GPIO.IN)
```

Затем запускаем вечный цикл и работаем с сигналами и видеопотоком:
```python3
while True:
    value = GPIO.input(SENS)  
    if value:  # если есть сигнал с датчика
        ret, frame = cap.read()  # читаем кадр из потока
        
        if frame is None:
            break  # если кадр получить не удалось, уходим
```

Передаем на вход сети кадр и получаем решение:
```python3
frame = cv.resize(frame, (200, 200))
rows = frame.shape[0]
cols = frame.shape[1]
net.setInput(cv.dnn.blobFromImage(frame, size=(100, 100), swapRB=True, crop=False))
netOut = net.forward()
```

Если сеть обнаружила объект, выделим его область:
```python3
for detection in netOut[0, 0, :, :]:
    score = float(detection[2])
    if score > 0.5:  # если сеть уверена на 50% в своей "находке"
        idx = int(detection[1])  # idx = 1 -> human

        # границы области, на которой обнаружен объект
        left = detection[3] * cols
        top = detection[4] * rows
        right = detection[5] * cols
        bottom = detection[6] * rows
```

Если обнаруженный объект - человек, применим сравнение кадров раз в freq кадров и выделим контуры обнаруженного движения:
```python3
if idx == 1:  # определяем движение человека
    # будем сравнивать кадры, если между ними есть разница
    # выделим ее. Подробнее этот алгоритм можно изучить в
    # файле motion_detection.py (там определяется любое движение)
    gray = cv.cvtColor(frame, cv.COLOR_BGR2GRAY)
    gray = cv.GaussianBlur(gray, (21, 21), 0)

    if first_frame is None or count > freq and count % freq == 1:
        prev_frame = frame
        first_frame = gray

    frame_delta = cv.absdiff(first_frame, gray)
    thresh = cv.threshold(frame_delta, 70, 255, cv.THRESH_BINARY)[1]
    thresh = cv.dilate(thresh, None, iterations=2)
    contours, _ = cv.findContours(thresh.copy(), cv.RETR_EXTERNAL, cv.CHAIN_APPROX_SIMPLE)

    for c in contours:
        x, y, w, h = cv.boundingRect(c)
        # зарисуем границы обнаруженного движения, только если
        # это относится к человеку (в границах области)
        if left <= x <= right and top <= y <= bottom:
            cv.rectangle(frame, (x, y), (x + w, y + h), (0, 0, 250), 2)
```

Выделим обнаруженный объект, не важно, человек это или нет. К каждому объекту также присваевается номер. У человека номер 1:
```python3
cv.rectangle(frame, (int(left), int(top)), (int(right), int(bottom)), (23, 230, 210), thickness=2)
y = int(top) - 15 if int(top) - 15 > 15 else int(top) + 15
cv.putText(frame, str(idx), (int(left), y), cv.FONT_HERSHEY_SIMPLEX, 0.5, (100, 100, 100), 2)
```

Затем выведем картинку со всеми изменениями:
```python3
cv.imshow('stream', frame)  # выводим обработанную картинку
```

При нажатии Esc работа завершается:
```python3
    k = cv.waitKey(30) & 0xff
    if k == 27:  # выходим при нажатии Esc
        break

cv.destroyAllWindows()
cap.release()
```
