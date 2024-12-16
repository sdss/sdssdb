from roboscheduler.cadence import CadenceList

clist = CadenceList()
clist.fromcfg("bright_mc_ext.cfg")

clist.tocsv("bright_mc_ext.csv")
