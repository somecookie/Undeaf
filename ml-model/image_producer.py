import numpy
import cv2
import sys
import os

"""

The role of this script is to collect an image dataset. It saves each two frames as a 200x200 jpeg. Press q to starting saving the images.

argv[1]: name folder
argv[2]: number of photos
argv[3]: first photo number
"""

name = "A" if len(sys.argv) < 2 else sys.argv[1]
max_photos = 500 if len(sys.argv) < 3 else int(sys.argv[2])
photo_id = 0 if len(sys.argv) < 4 else int(sys.argv[3])
inital_id = photo_id
frame_nbr = 0

folder_path = os.getcwd()+"/dataset/{}/".format(name)
if not os.path.exists(folder_path):
    os.makedirs(folder_path)

x1, y1, x2, y2 = 200, 200, 400, 400

cap = cv2.VideoCapture(0)

while True:
    ret, img = cap.read()
    img = cv2.flip(img, 1)
    cv2.rectangle(img, (x1, y1), (x2, y2), (255,0,0), 2)
    cv2.imshow("img", img)
    if cv2.waitKey(1) & 0xFF == ord('q'):
        break


while(photo_id < max_photos+inital_id):
    # Capture frame-by-frame
    ret, img = cap.read()
    if ret:
        #flip image
        img = cv2.flip(img, 1)
	
    #crop image to get only the 200x200 image
    img_cropped = img[y1:y2, x1:x2]
    image_data = cv2.imencode('.jpg', img_cropped)[1].tostring()
    cv2.rectangle(img, (x1, y1), (x2, y2), (255,0,0), 2)
    cv2.imshow("img", img)
	
    #save frame
    path_name = folder_path+"frame_{}.jpg".format(photo_id)
    	
    if frame_nbr % 2 == 0:
        print("Saved: {}".format(path_name))
        cv2.imwrite(path_name, img_cropped)
        photo_id += 1

    if cv2.waitKey(1) & 0xFF == ord('q'):
        break

    frame_nbr += 1
    

# When everything done, release the capture
cap.release()
cv2.destroyAllWindows()
