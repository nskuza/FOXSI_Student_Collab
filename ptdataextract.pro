; This file will extract data for a task that involves placing a singke point with a verbal descriptor of the point.
; These tasks are virtually the same as multiple choice tasks but witht he added factor of a point being placed. 
 
task = 0
; This indicates the task number being analyzed.

a = 5
; Number of answers or options available for the task.
 
verbal = ['At a footpoint of the flare.','On a flare arch.','Above a flare arch but not on an arch.','Inside an arch but not on it.','Not related to a flare arch.']
; Verbal responses for each of the options

;-------------------------------- User must set variables above this line.---------------------------------------

ptArrayS = MAKE_ARRAY(TI[task]*3, /STRING, VALUE = '')
ptArrayX = MAKE_ARRAY(TI[task]*3, /DOUBLE, VALUE = 0.0)
ptArrayY = MAKE_ARRAY(TI[task]*3, /DOUBLE, VALUE = 0.0)
; ptArrayS is the array of string responses. ptArrayX is the X values and ptArrayY is the y. Their length
; is 3x the number of resonses because individuals can respond multiple times. Increase the multiplication
; factor if INDEX is out of range.

inputData = taskSet[task].datString
index = 0

FOR I=0, TI[task] DO BEGIN
  temp = inputData[I].Split('},{')
  ; Splits the String by the substring '},{' which repeatedly seperates individual responses, thus ensuring that
  ; only one data point is in ech temp array.
  Idat = N_ELEMENTS(temp) - 1
  FOR J=0, Idat DO BEGIN ; One loop for every data point.
    FOR K=0, a-1 DO BEGIN ; One loop for every possible response.
      IF (temp[J].Contains(verbal[K]) EQ 1) THEN BEGIN
        ptArrayS[index] = verbal[K]
        ; The verbal response is recorded as a String
        xString = temp[J].Extract('"x":[0123456789.]{6}')
        xString = xString.Remove(0,3)
        ptArrayX[index] = DOUBLE(xString)
        ; The x value is created by extracting the specific set of text that contains the x value. It is then altered to
        ; contain just the double to be stored. The value will always be at most 4 signifigant figures.     
        yString = temp[J].Extract('"y":[0123456789.]{6}')
        yString = yString.Remove(0,3)
        ptArrayY[index] = DOUBLE(YString)
        ; The y value is created by extracting the specific set of text that contains the x value. It is then altered to
        ; contain just the double to be stored. The value will always be at most 4 signifigant figures.
        index = index + 1
      ENDIF
    ENDFOR
  ENDFOR
ENDFOR
; Triple nested FOR Loops once again. Open to revisionary edits.

ptOutput = {class:taskSet[task].classificationID, subject:taskSet[task].subjectID, verbal:ptArrayS, xValue:ptArrayX, yValue:ptArrayY}
; Final data set produced from a Point Placement(Pt) task.
END
