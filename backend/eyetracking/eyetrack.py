import cv2
import dlib
import numpy as np

def eyetract(byteImg):

    # 얼굴 인식 및 특징점 추출 모델 로드
    detector = dlib.get_frontal_face_detector()
    predictor = dlib.shape_predictor('eyetracking/shape_predictor_68_face_landmarks.dat')

    # 바이트 데이터 -> 이미지
    byteData = byteImg
    nparr = np.frombuffer(byteData, np.uint8)
    img = cv2.imdecode(nparr, cv2.IMREAD_COLOR)

    # 얼굴 인식
    faces = detector(img)

    # 인식이 되지 않은 경우
    if len(faces) == 0:
        return -1

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

        _, threshold_left_eye = cv2.threshold(gray_roi_left_eye, 50, 255, cv2.THRESH_BINARY_INV)
        contours_left_eye, _ = cv2.findContours(threshold_left_eye, cv2.RETR_TREE, cv2.CHAIN_APPROX_SIMPLE)
        contours_left_eye = sorted(contours_left_eye, key=lambda x: cv2.contourArea(x), reverse=True)

        # 오른쪽 눈 처리
        gray_roi_right_eye = cv2.cvtColor(roi_right_eye, cv2.COLOR_BGR2GRAY)
        gray_roi_right_eye = cv2.GaussianBlur(gray_roi_right_eye, (5,5), 0)

        _, threshold_right_eye = cv2.threshold(gray_roi_right_eye, 50, 255, cv2.THRESH_BINARY_INV)
        contours_right_eye, _ = cv2.findContours(threshold_right_eye, cv2.RETR_TREE, cv2.CHAIN_APPROX_SIMPLE)
        contours_right_eye = sorted(contours_right_eye, key=lambda x: cv2.contourArea(x), reverse=True)

        etCount = 0

        # 왼쪽 눈동자 위치 찾기 및 컨투어 그리기
        if len(contours_left_eye) > 0:
            c1 = max(contours_left_eye,key=cv2.contourArea)
            (x1,y1,w1,h1) = cv2.boundingRect(c1)
            pupil_center_x1 = x1 + w1 // 2 + left_eye_x
            pupil_center_y1 = y1 + h1 // 2 + left_eye_y

            if pupil_center_y1 < left_eye_y + left_eye_h // 2:
                print("왼쪽 눈이 위를 보고 있습니다.")
                etCount += 1
            elif pupil_center_y1 > left_eye_y + left_eye_h // 2:
                print("왼쪽 눈이 아래를 보고 있습니다.")
                etCount += 1

            if pupil_center_x1 < left_eye_x + left_eye_w // 2:
                print("왼쪽 눈이 왼쪽을 보고 있습니다.")
                etCount += 1
            elif pupil_center_x1 > left_eye_x + left_eye_w // 2:
                print("왼쪽 눈이 오른쪽을 보고 있습니다.")
                etCount += 1

        # 오른쪽 눈동자 위치 찾기 및 컨투어 그리기
        if len(contours_right_eye) > 0:
            c2 = max(contours_right_eye,key=cv2.contourArea)
            (x2,y2,w2,h2) = cv2.boundingRect(c2)
            pupil_center_x2 = x2 + w2 // 2 + right_eye_x
            pupil_center_y2 = y2 + h2 // 2 + right_eye_y

            if pupil_center_y2 < right_eye_y + right_eye_h // 2:
                print("오른쪽 눈이 위를 보고 있습니다.")
                etCount += 1
            elif pupil_center_y2 > right_eye_y + right_eye_h // 2:
                print("오른쪽 눈이 아래를 보고 있습니다.")
                etCount += 1

            if pupil_center_x2 < right_eye_x + right_eye_w // 2:
                print("오른쪽 눈이 왼쪽을 보고 있습니다.")
                etCount += 1
            elif pupil_center_x2 > right_eye_x + right_eye_w // 2:
                print("오른쪽 눈이 오른쪽을 보고 있습니다.")
                etCount += 1

    return etCount

if __name__ == '__main__':
    eyetract()