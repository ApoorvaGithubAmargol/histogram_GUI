import cv2
import numpy as np
from skimage.feature import canny
from skimage.measure import regionprops, label
from skimage.filters import laplace
from skimage.color import rgb2hsv
from scipy.spatial.distance import euclidean

def detect_blur(image, threshold=100):
    gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)
    variance_of_laplacian = cv2.Laplacian(gray, cv2.CV_64F).var()
    return variance_of_laplacian < threshold

def segment_teeth(image):
    gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)
    blurred = cv2.GaussianBlur(gray, (5, 5), 0)
    thresh = cv2.threshold(blurred, 0, 255, cv2.THRESH_BINARY + cv2.THRESH_OTSU)[1]
    labeled = label(thresh)
    regions = regionprops(labeled)
    tooth_regions = []
        if 200 < region.area < 5000: # Example area filter
            tooth_regions.append(region)
    return tooth_regions

def extract_intensity_features(region, original_image):
    minr, minc, maxr, maxc = region.bbox
    tooth_image = original_image[minr:maxr, minc:maxc]
    gray_tooth = cv2.cvtColor(tooth_image, cv2.COLOR_BGR2GRAY)
    return np.mean(gray_tooth)

def extract_color_features(region, original_image):
    minr, minc, maxr, maxc = region.bbox
    tooth_image = original_image[minr:maxr, minc:maxc]
    return np.mean(tooth_image, axis=(0, 1)) # Mean RGB

tooth_shades = {
    "A1": {"rgb": [240, 230, 215], "intensity": 230},
    "A2": {"rgb": [235, 220, 205], "intensity": 220},
}

def compare_intensity(tooth_intensity, shade_data):
    return abs(tooth_intensity - shade_data["intensity"])

def compare_color(tooth_color, shade_data):
    return euclidean(np.array(tooth_color), np.array(shade_data["rgb"]))

def compare_tooth_to_guide(tooth_region, original_image, shade_guide, intensity_weight=0.5, color_weight=0.5):
    tooth_intensity = extract_intensity_features(tooth_region, original_image)
    tooth_color = extract_color_features(tooth_region, original_image)
    scores = {}
    for shade, data in shade_guide.items():
        intensity_diff = compare_intensity(tooth_intensity, data)
        color_diff = compare_color(tooth_color, data)
        combined_score = (intensity_weight * intensity_diff) + (color_weight * color_diff)
        scores[shade] = combined_score
    return scores

def get_closest_shades(comparison_scores, top_n=3):
    sorted_shades = sorted(comparison_scores.items(), key=lambda item: item[1])
    return sorted_shades[:top_n]

if _name_ == "_main_":
    image_path = "path/to/your/mouth_image.jpg"
    original_image = cv2.imread(image_path)

    if original_image is None:
        print("Error: Could not open or find the image.")
    elif detect_blur(original_image):
        print("Image is blurry. Please retake the image.")
    else:
        tooth_regions = segment_teeth(original_image)
        if not tooth_regions:
            print("Could not detect any teeth in the image.")
        else:
            all_comparison_results = []
            for i, region in enumerate(tooth_regions):
                scores = compare_tooth_to_guide(region, original_image, tooth_shades)
                print(f"Comparison results for tooth {i+1}:")
                closest_shades = get_closest_shades(scores)
                for shade, score in closest_shades:
                    print(f"  - {shade}: {score:.2f}")
                all_comparison_results.append(closest_shades)