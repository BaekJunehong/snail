import cv2
import dlib

# 얼굴 인식 및 특징점 추출 모델 로드
detector = dlib.get_frontal_face_detector()
predictor = dlib.shape_predictor('backend/eyetracking\shape_predictor_68_face_landmarks.dat')

# 웹캠 열기
cap = cv2.VideoCapture(0)

while True:
    # 웹캠에서 프레임 읽기
    ret, img = cap.read()

    if not ret:
        break

    # 얼굴 인식
    faces = detector(img)

    for face in faces:
        # 얼굴 특징점 추출
        landmarks = predictor(img, face)

        # 왼쪽 눈 위치 찾기
        left_eye_x = min(landmarks.part(n).x for n in range(36, 42))
        left_eye_y = min(landmarks.part(n).y for n in range(36, 42))
        left_eye_w = max(landmarks.part(n).x for n in range(36, 42)) - left_eye_x
        left_eye_h = max(landmarks.part(n).y for n in range(36, 42)) - left_eye_y

        # 오른쪽 눈 위치 찾기
        right_eye_x = min(landmarks.part(n).x for n in range(42, 48))
        right_eye_y = min(landmarks.part(n).y for n in range(42, 48))
        right_eye_w = max(landmarks.part(n).x for n in range(42, 48)) - right_eye_x
        right_eye_h = max(landmarks.part(n).y for n in range(42, 48)) - right_eye_y

        # 눈 영역 설정
        roi_left_eye = img[left_eye_y:left_eye_y+left_eye_h, left_eye_x:left_eye_x+left_eye_w]
        roi_right_eye = img[right_eye_y:right_eye_y+right_eye_h, right_eye_x:right_eye_x+right_eye_w]

        # 왼쪽 눈 처리
        gray_roi_left_eye = cv2.cvtColor(roi_left_eye, cv2.COLOR_BGR2GRAY)
        gray_roi_left_eye = cv2.GaussianBlur(gray_roi_left_eye, (5,5), 0)

        _, threshold_left_eye = cv2.threshold(gray_roi_left_eye, 35, 255, cv2.THRESH_BINARY_INV)
        contours_left_eye, _ = cv2.findContours(threshold_left_eye, cv2.RETR_TREE, cv2.CHAIN_APPROX_SIMPLE)
        contours_left_eye = sorted(contours_left_eye, key=lambda x: cv2.contourArea(x), reverse=True)

        # 오른쪽 눈 처리
        gray_roi_right_eye = cv2.cvtColor(roi_right_eye, cv2.COLOR_BGR2GRAY)
        gray_roi_right_eye = cv2.GaussianBlur(gray_roi_right_eye, (5,5), 0)

        _, threshold_right_eye = cv2.threshold(gray_roi_right_eye, 35, 255, cv2.THRESH_BINARY_INV)
        contours_right_eye, _ = cv2.findContours(threshold_right_eye, cv2.RETR_TREE, cv2.CHAIN_APPROX_SIMPLE)
        contours_right_eye = sorted(contours_right_eye, key=lambda x: cv2.contourArea(x), reverse=True)

        # 왼쪽 눈동자 위치 찾기 및 컨투어 그리기
        if len(contours_left_eye) > 0:
            c1 = max(contours_left_eye, key=cv2.contourArea)
            cv2.drawContours(roi_left_eye, [c1], 0, (0,0,255), 3)

            # 오른쪽 눈동자 위치 찾기 및 컨투어 그리기
            if len(contours_right_eye) > 0:
                c2 = max(contours_right_eye,key=cv2.contourArea)
                cv2.drawContours(roi_right_eye, [c2], 0,(0,0,255),3)

            # Draw rectangles around eyes on original image
            img=cv2.rectangle(img,(left_eye_x,left_eye_y),(left_eye_x+left_eye_w,left_eye_y+left_eye_h),(0,255,0),1)
            img=cv2.rectangle(img,(right_eye_x,right_eye_y),(right_eye_x+right_eye_w,right_eye_y+right_eye_h),(0,255,0),1)

    # 결과 출력
    cv2.imshow("Frame", img)

    # 'q'키를 누르면 종료
    if cv2.waitKey(1) & 0xFF == ord('q'):
        break

# 웹캠 해제 및 모든 창 닫기
cap.release()
cv2.destroyAllWindows()
