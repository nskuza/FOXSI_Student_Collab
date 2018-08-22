# FOXSI_Student_Collab
# Author(s): Nick Skuza

## Code for data extraction and analysis of citizen science research related to the FOXSI Collaboration ##

Below is a list of each script file with its function(s) and the variables it produces that are useful to the user:

	A) readParseStore.pro => Reads in the data file and puts it into a usable format.

		Important Output Variables:
 
			a) taskSet => DATA STRUCTURE ARRAY that contains an n dimensional data set for each task label. The
			              indices correspond to the proper task number. Each data set contains an 
			              array of classificationIDs, subjectIDs, and datStrings with each index referencing
			              a specific data point. The arrays contain the following information:

					i) classificationID => Indicates which classification it came from.
					ii) subjectID => Indicates which image it is in reference to.
					iii) datString => Contains a single STRING with all responses for the respective
					                  task.
  
			b) TI => INTEGER ARRAY which keeps track of how many data points exist for each task. The indices
			         correspond to the task numbers.

	B) MCdataExtract.pro => Extracts the data for a multiple choice task regardless of DATA_TYPE.

		Important Output Variables:

			a) mcOutput => DATA STRUCTURE which contains an array of classificationIDs, subjectIDs, 
			               and data with each index referencing a specific data point. The arrays contain
			               the following information:

					i) class => Indicates which classification it came from.
					ii) subject => Indicates which image it is in reference to.
					iii) mcData => contains the data in whichever DATA_TYPE is most useful.

	C) ptdataextract.pro => Extracts the data for any point placement tasks. This includes any verbal desccription
                                and the x and y coordinates of the point itself.

		Important Output Variables:

			a) ptOutput => DATA STRUCTURE which contains an array of classificationIDs, subjectIDs, 
			               and the points with each index referencing a specific response. The 
                                       arrays contain the following information:

					i) class => Indicates which classification it came from.
					ii) subject => Indicates which image it is in reference to.
					iii) verbal => contains the verbal description associated with the 
                                                       point that was placed
					iv) xValue => the x-Value of point that was placed 
					v) yValue => the y-Value of point that was placed

	D) bezierExtract.pro => Extracts the verbal descriptions and points which define a particular
                                Bezier curve.

		Important Output Variables:

			a) bzOutput => DATA STRUCTURE which contains an array of classificationIDs, subjectIDs, 
			               verbal responses as well as the actual points that define Bezier curves. Each
                                       index of the arrays indicates an individual curve that was placed. Multiple
                                       seperate indexes could have been placed by the same person:

					i) class => Indicates which classification it came from.
					ii) subject => Indicates which image it is in reference to.
					iii) verbal => contains the verbal description associated with the 
                                                       point that was placed
					iv) xValues => contains all the xValues defining a curve that was placed 
					v) yValues => contains all the yValues defining a curve that was placed

In each data extraction file there is a header section in which the user must set the necessary variables. The variables you
must set before running each file are:

	A) readParseStoreData.pro

		datFile == The file containing data to be read. Enter as a STRING.

		workFlowID == The workflow you are extracting data from. Look for the ID number either in the data file
		              or on the workflow editor page. Enter as an INTEGER.

		workflowVersion == The workflow version that is being analyzed. Check the version in the data file.
		                   Best practice would be to record the version number before taking data. Enter as
		                   a FLOAT.

		tasks == The number of tasks in the version being analyzed. Will analyze from task 0 forward. Enter 
		         as an INTEGER.

	B) MCdataExtract.pro

		task == The specific task from the workflow version being analyzed. Enter as an INTEGER.

		a == The number of options for the users to respond with. Enter as an INTEGER.

		MC == The multiple choice answers that correspond to each of the 'a' options. Enter as an 'a' 
		      dimensional STRING ARRAY with each option explicitly written out the same as is specified
		      in the workflow editor.

		value == The values that will be assigned for each of the options. Make sure that the values correspond
			 1-for-1 with string responses. Enter manually as an ARRAY of TYPE = DATA_TYPE.

		mcArray == This will become the array of values that will be extracted. The only thing the user 
		           should edit are the DATA_TYPE and the default VALUE. The DATA_TYPE MUST match the 
		           DATA_TYPE of the value array.

	C) ptdataextract.pro

		task == The specific task from the workflow version being analyzed. Enter as an INTEGER.

		a == The number of options for the users to respond with. Enter as an INTEGER.

		verbal == This is a STRING ARRAY of the verbal descriptions associated with points being placed
		          in a point placing task. It will have length equal to 'a' and the user will have to 
                          explicitly define the strings to be exactly the same as they are written in Zooniverse

	D) bezierExtract.pro

		task == The specific task from the workflow version being analyzed. Enter as an INTEGER.

		a == The number of options for the users to respond with. Enter as an INTEGER.

		verbal == This is a two dimensional STRING ARRAY of the verbal descriptions associated with curves being
                          placed in a Bezier Curve task. It will have length equal to 'a' and the user will have to 
                          explicitly define the strings to be exactly the same as they are written in Zooniverse.  

 
		 

		 


