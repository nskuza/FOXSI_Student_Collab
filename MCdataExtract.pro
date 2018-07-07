; This is a sample of how the multiple choice question extractor will work. It will have to be edited a bit more to
; merge with the readParseStoreData.pro file once that one is completed and generalized.

q = 5
; This is where the number of questions for the task. Make sure it is equal to the length of the 'MC' and 'value' arrays.

MC = ['1','2','3','4 or more','0']
; Always define the multiple choice options here as strings. 

value = [1,2,3,4,0]
; The strings indicated above will be converted into these values here. Make sure if the value is numeric.
; it is cast as the correct object type.

datArray = MAKE_ARRAY(100, /INTEGER, VALUE = -1)
; Define the data array with the proper data type. Length should typically be carried over from CSV read script.
; Set every entry to a default value that is distinct from all possible response values.

;-------------------------------- User must set variables above this line.---------------------------------------

s = strarr(100)
; This is a temporary representation of the data as it is fed into the script. 

FOR I=0, 20 DO BEGIN
  s[I] = '"T2","task_label":"How many arch-like structures are visible in the image?","value":"0 "}'
  s[I+20] = '"T2","task_label":"How many arch-like structures are visible in the image?","value":"2 "}'
  s[I+41] = '"T2","task_label":"How many arch-like structures are visible in the image?","value":"3 "}'
  s[I+62] = '"T2","task_label":"How many arch-like structures are visible in the image?","value":"4 or more "}'
ENDFOR
; Simulation of what incoming data might look like for any paticular task. 
   
FOR I=0, 99 DO BEGIN
  temp = s[I].Split('"value":"')
  Idat = N_ELEMENTS(temp) - 1
  FOR J=0, q-1 DO BEGIN
    IF(temp[Idat].Contains(MC[J]) EQ 1) THEN BEGIN
      datArray[I] = value[J]
    ENDIF
  ENDFOR 
ENDFOR

END