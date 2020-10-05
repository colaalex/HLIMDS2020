import cv2 as cv

# https://github.com/opencv/opencv/wiki/TensorFlow-Object-Detection-API#use-existing-config-file-for-your-model
model = 'frozen_inference_graph.pb'
config = 'mobilenet_config.pbtxt'
net = cv.dnn.readNetFromTensorflow(model, config)  # сеть на обученной модели

cap = cv.VideoCapture(cv.CAP_DSHOW)  # получаем кадры с камеры
# first_frame и prev_frame используются для сравнения кадров
first_frame = None
prev_frame = None

# в данном алгоритме идет сравнение не каждого кадра
# (если параметр freq не равен 1), а с преиодичностью раз в
# freq кадров
count = 0
freq = 1

while True:
    ret, frame = cap.read()  # читаем кадр из потока

    if frame is None:
        break  # если кадр получить не удалось, уходим

    # подаем кадр на вход сети
    rows = frame.shape[0]
    cols = frame.shape[1]
    net.setInput(cv.dnn.blobFromImage(frame, size=(300, 300), swapRB=True, crop=False))
    # и получаем вывод
    netOut = net.forward()

    # проходимся по всем "находкам" сети
    for detection in netOut[0, 0, :, :]:
        score = float(detection[2])
        if score > 0.6:  # если сеть уверена на 60% в своей "находке"
            idx = int(detection[1])  # idx = 1 -> human

            # границы области, на которой обнаружен объект
            left = detection[3] * cols
            top = detection[4] * rows
            right = detection[5] * cols
            bottom = detection[6] * rows

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

            # выделяем объект
            cv.rectangle(frame, (int(left), int(top)), (int(right), int(bottom)), (23, 230, 210), thickness=2)
            y = int(top) - 15 if int(top) - 15 > 15 else int(top) + 15
            cv.putText(frame, str(idx), (int(left), y), cv.FONT_HERSHEY_SIMPLEX, 0.5, (100, 100, 100), 2)

    cv.imshow('stream', frame)  # выводим обработанную картинку

    k = cv.waitKey(30) & 0xff
    if k == 27:  # выходим при нажатии Esc
        break

cv.destroyAllWindows()
cap.release()
