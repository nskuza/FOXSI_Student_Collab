; This is a sample of how the multiple choice question extractor will work. There are five variables for the user to set.

task = 2
; This sets the task from readParsetoreData.pro to be anaylzed
a = 5
; This is the number of answers for the task. Make sure it is equal to the length of the 'MC' and 'value' arrays.

MC = ['1','2','3','4 or more','0']
; Always define the multiple choice options here as strings. 
value = [1,2,3,4,0]
; The strings indicated above will be converted into these values here. Make sure if the value is numeric.
; it is cast as the correct object type.

mcArray = MAKE_ARRAY(TI[task], /INTEGER, VALUE = -1)
; Define the multiple choice data array with the proper data type. Length is set by the number of data points from 
; the task being analyzed. This value is set above. Every entry to a default value that is distinct from all possible response values.

;-------------------------------- User must set variables above this line.---------------------------------------

inputData = taskSet[task].datString
; Input data from readParseData.pro.
   
FOR I=0, TI[task] DO BEGIN
  temp = inputData[I].Split('"value":"')
  Idat = N_ELEMENTS(temp) - 1
  FOR J=0, a-1 DO BEGIN
    IF(temp[Idat].Contains(MC[J]) EQ 1) THEN BEGIN
      mcArray[I] = value[J]
    ENDIF
  ENDFOR 
ENDFOR
; This extracts and converts the data. The string "value":" will be in every Zooniverse multiple choice response
; and the value, regardless of data type, will immediaely follow it.
mcOutput = {class:taskSet[task].classificationID, subject:taskSet[task].subjectID, mcData:mcArray}
; Final data set produced from a Multiple Choice(MC) task. 

END