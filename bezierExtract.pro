; This file will extract data for a Bezier curve with 3-5 X and Y points being stored but also recording the 
; verbal descriptions associated with each color. In this case those descriptions are of the brightness.

task = 1
; This indicates the task number being analyzed.

a = 4
; Number of answers or options available for the task.
verbal = MAKE_ARRAY(a, /STRING, VALUE = '') 
verbal[0] = 'Outline the brightest flare structure.'
verbal[1] = 'Outline the second brightest arch if there is one.'
verbal[2] = 'Outline the third brightest arch if there is one.'
verbal[3] = 'Outline the fourth brightest arch if there is one.'
; Verbal responses for each of the options

;-------------------------------- User must set variables above this line.---------------------------------------

bzArrayS = MAKE_ARRAY(TI[task]*3, /STRING, VALUE = '')
bzArrayX = MAKE_ARRAY(5, TI[task]*3, /DOUBLE, VALUE = 0.0)
bzArrayY = MAKE_ARRAY(5, TI[task]*3, /DOUBLE, VALUE = 0.0)
; These arrays will contain the data for each data point. Up to five data points for x and y can be stored. The second
; number is three times the number of responses to ensure all arches that were drawn are recorded.

inputData = taskSet[task].datString
index = 0

FOR I=0, TI[task] DO BEGIN
  tempA = inputData[I].Split('}]}')
  ; Splits the String by the substring '}]}' which repeatedly ends individual responses, thus ensuring that
  ; only response is in each tempA array.
  
  Iarc = N_ELEMENTS(tempA) - 1
  ; Number of arches placed by the user within one response 
  FOR L=0, Iarc DO BEGIN
    
    tempB = tempA[L].Split('},{')
    ; Splits the response into its indivudually placed points
  
    Ipts = N_ELEMENTS(tempB) - 1
    ; Number of points placed in the response
    
    points = 0 ; number of points recorded for a particular arch. Increments the number of points stored.
    FOR J=0, Ipts DO BEGIN
      IF (tempB[J].Contains('"x"') EQ 1 AND tempB[J].Contains('"y"') EQ 1 AND points LT 5) THEN BEGIN
        xString = tempB[J].Extract('"x":[0123456789.]{6}')
        xString = xString.Remove(0,3)
        bzArrayX[points, index] = DOUBLE(xString)
        ; The x value is created by extracting the specific set of text that contains the x value. It is then altered to
        ; contain just the double to be stored. The value will always be at most 4 signifigant figures.
        yString = tempB[J].Extract('"y":[0123456789.]{6}')
        yString = yString.Remove(0,3)
        bzArrayY[points, index] = DOUBLE(YString)
        ; The y value is created by extracting the specific set of text that contains the x value. It is then altered to
        ; contain just the double to be stored. The value will always be at most 4 signifigant figures.
        points = points + 1
      ENDIF
    ENDFOR
    ; This FOR loop finds up to 5 data points within the 
  
    FOR K=0, a-1 DO BEGIN ; One loop for every possible response.
      IF (tempA[L].Contains(verbal[K]) EQ 1) THEN BEGIN
        bzArrayS[index] = verbal[K]
        index = index + 1
        ; The verbal response is recorded as a String
      ENDIF
    ENDFOR
  ENDFOR  
ENDFOR
; Triple nested FOR Loops once again. Open to revisionary edits.

bzOutput = {class:taskSet[task].classificationID, subject:taskSet[task].subjectID, verbal:bzArrayS, xValue:bzArrayX, yValue:bzArrayY}
; Final data set produced from a Point Placement(Pt) task.
END