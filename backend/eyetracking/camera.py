import cv2

class VideoCamera(object):
    def __init__(self):
        self.video = cv2.VideoCapture(0)            # 웹캠
        #self.video = cv2.VideoCapture('video.mp4')  # mp4 사용

    def __del__(self):
        self.video.release()

    # 카메라 화면 띄우기
    def get_cam_window(self):
        ret, self.window = self.video.read()
        return self.window
    
    # 스크린샷
    def get_scr_img(self):
        ret, jpg = cv2.imencode('.jpg', self.window)

        # 현재는 파일을 저장하지만, 서비스에서는 저장없이 byte 정보만 사용
        with open('screenshot.jpg', "wb") as f:
            f.write(jpg.tobytes())

if __name__ == '__main__':
    cam = VideoCamera()
    while True:
        window = cam.get_cam_window()

        cv2.imshow('Camera Test', window)
        key = cv2.waitKey(1) & 0xFF

        # if the `q` key was pressed, break from the loop
        if key == ord("q"):
            break
        if key == ord("s"):
            cam.get_scr_img() 

    # do a bit of cleanup
    cv2.destroyAllWindows()
    print('finish')