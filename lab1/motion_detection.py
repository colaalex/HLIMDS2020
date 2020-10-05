import cv2

cap = cv2.VideoCapture(cv2.CAP_DSHOW)
first_frame = None
prev_frame = None

count = 0
while True:
    ret, frame = cap.read()
    count += 1

    if frame is None:
        break

    gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
    gray = cv2.GaussianBlur(gray, (21, 21), 0)

    freq = 25
    if first_frame is None or count > freq and count % freq == 1:
        prev_frame = frame
        first_frame = gray

    frame_delta = cv2.absdiff(first_frame, gray)
    thresh = cv2.threshold(frame_delta, 25, 255, cv2.THRESH_BINARY)[1]
    thresh = cv2.dilate(thresh, None, iterations=2)
    _, contours, _ = cv2.findContours(thresh.copy(), cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)

    for c in contours:
        x, y, w, h = cv2.boundingRect(c)
        cv2.rectangle(frame, (x, y), (x + w, y + h), (0, 255, 0), -1)
    #         prev_crop = prev_frame[y:y+h, x:x+w]
    #         frame[y:y+h, x:x+w] = prev_crop

    cv2.imshow("Frame", frame)
    cv2.imshow("Thresh", thresh)
    cv2.imshow("Delta", frame_delta)

    k = cv2.waitKey(30) & 0xff
    if k == 27:
        break

cv2.destroyAllWindows()
cap.release()
