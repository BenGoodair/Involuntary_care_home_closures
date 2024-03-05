*======================================================
*Replication file for Lancet Healthy Longevity analysis
*======================================================

*use involuntary closures_replicationdata_1.csv
*----------------------------------------------------
* Table 1 
*----------------------------------------------------
//forced closures
tab ownership if forced_closure==1

tabstat company individual_partnership disabled mental_health detained  dementia nurse age carehomesbeds inadequate requiresimprovement good  outstanding missing_quality if forced_closure==1,  stat(mean sd sum count)   
//complete closured (not counting changes)
tab ownership if closed_complete==1

 tabstat company individual_partnership disabled mental_health detained  dementia nurse age carehomesbeds inadequate requiresimprovement good  outstanding missing_quality if closed_complete==1,  stat(mean sd sum count)   

//active homes
tab ownership if year_location_end==.

tabstat company individual_partnership disabled mental_health detained  dementia nurse age carehomesbeds inadequate requiresimprovement good  outstanding missing_quality if year_location_end==. ,  stat(mean sd sum count)   

*----------------------------------------------------
* Figure 2
*----------------------------------------------------
* use same data as above
graph bar (mean) inadequate, over(ownership)  ytitle("Percent of homes rated inadequate (%, all inspected homes, 2011-2023)") 

graph bar (mean) forced_closure, over(ownership)  ytitle("Percent of homes involuntarily closed (% of all homes, 2011-2023)") 

graph bar (mean) inadequate requiresimprovement good  outstanding if forced_closure==1, ytitle("Percent of homes involuntarily closed (%)") 

*clear this dataset and open involuntary closures_replicationdata_2.csv
*----------------------------------------------------
* Figure 1
*----------------------------------------------------
graph bar  force_closed_beds closedbeds_adjusted if year_location_start!=2010, over(year_location_end, label(angle(45))) stack title("C) Closed beds (count)") legend(order(1 "Involuntary closure" 2 "Voluntary closure"))   graphregion(col(white) icol(white)) plotregion(fcolor(white))  saving(forcedclosure_number, replace)

graph bar  proportion_forced_beds prop_bed_allclosures if year_location_start!=2010, over(year_location_end, label(angle(45)))  stack title("D) Closed beds (%)") legend(order(1 "Involuntary closure" 2 "Voluntary closure")) graphregion(col(white) icol(white)) plotregion(fcolor(white))  saving(forcedclosure_perc, replace)

graph bar  forced_closures_england total_closures_adjusted if year_location_start!=2010, over(year_location_end, label(angle(45)))  stack title("A) Closed homes (count)")  legend(order(1 "Involuntary closure" 2 "Voluntary closure"))  graphregion(col(white) icol(white)) plotregion(fcolor(white))  saving(forcedclosure_number_home, replace)

graph bar  proportion_forced_closures prop_home_allclosures if year_location_start!=2010, over(year_location_end, label(angle(45)))  stack title("B) Closed homes (%)")  legend(order(1 "Involuntary closure" 2 "Voluntary closure"))  graphregion(col(white) icol(white)) plotregion(fcolor(white))  saving(forcedclosure_perc_home, replace)

graph combine forcedclosure_number_home.gph forcedclosure_perc_home.gph forcedclosure_number.gph forcedclosure_perc.gph, graphregion(col(white) icol(white)) altshrink xcommon commonscheme 

grc1leg2 forcedclosure_number_home.gph forcedclosure_perc_home.gph forcedclosure_number.gph forcedclosure_perc.gph, graphregion(col(white) icol(white)) altshrink xcommon commonscheme position(3)


