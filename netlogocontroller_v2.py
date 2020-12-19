## --- pre requirments 
# pip install numpy                                                              
# pip insatll scipy
# pip install pandas
# pip install jpype1
import pyNetLogo
import PySimpleGUI as sg
#propmpting for input in netLogo Project
method = input("1.Enter From Scratch\n2.Edit From Previous Entry\nMethod:")
method=int(method)
if method == 1 : # from scratch
    number_trees_prompt = input('number-trees(0-2000) : ') 
    number_trees_prompt = str(number_trees_prompt) + "\n"
    fire_strength_prompt = input('fire-strength(1-20) : ') #239 
    fire_strength_prompt = str(fire_strength_prompt) +"\n"
    fire_radius_prompt = input('fire-radius(0.5 - 4):') # 307
    fire_radius_prompt = str(fire_radius_prompt) +"\n"
    wind_prompt = input('wind ON / OFF (y-n): ') # 368JPW 
    wind_flag = 'y'
    if wind_prompt == 'y': # 0 for on # 1 for off
        wind_prompt = '0'
        wind_prompt = str(wind_prompt)+"\n"
        wind_direction_prompt = input('wind direction(0 - 360):') # 355
        wind_direction_prompt = str(wind_direction_prompt)+"\n"
    if wind_prompt == 'n':
        wind_flag = 'n'
        wind_prompt ='1'
        wind_prompt = str(wind_prompt)+"\n"
    rain_prompt = input('rain ON / OFF : (y-n):') # 379
    rain_flag= 'y'
    if rain_prompt == 'y':
        rain_prompt = '0'
        rain_prompt = str(rain_prompt)+"\n"
        rain_rate = input('rain-rate (0-20):') #392
        rain_rate = str(rain_rate)+"\n"
    if rain_prompt == 'n':
        rain_flag = 'n'
        rain_prompt = '1'
        rain_prompt = str(rain_prompt)+"\n"
    spread_probability_prompt = input("spread probabilty(0-100): ") #418
    spread_probability_prompt = str(spread_probability_prompt) + "\n"
    big_jumps_prompt = input('big jumps (y -n) :') # 431
    if big_jumps_prompt =='y':
        big_jumps_prompt = '0'
    if big_jumps_prompt == 'n':
        big_jumps_prompt = '1'
    big_jumps_prompt = str(big_jumps_prompt)+"\n"
    # writing the prompted info to netlogo
    a_file=open("Forest Fire_v1.nlogo" , "r")
    list_of_lines = a_file.readlines()  # reading all lines in list_of_line vari
    list_of_lines[224] = number_trees_prompt
    list_of_lines[239] = fire_strength_prompt
    list_of_lines[307] = fire_radius_prompt
    list_of_lines[368] = wind_prompt
    if wind_flag == 'y':
        list_of_lines[355] = wind_direction_prompt
    list_of_lines[379] = rain_prompt
    if rain_flag =='y' :
        list_of_lines[392] = rain_rate
    list_of_lines[418] = spread_probability_prompt
    list_of_lines[431] = big_jumps_prompt
    a_file=open("Forest Fire_v1.nlogo","w")
    a_file.writelines(list_of_lines)
    a_file.close()
    netlogo = pyNetLogo.NetLogoLink(gui=True) # shows netlogo
    netlogo.load_model(r'Forest Fire_v1.nlogo') # laods the netlogo project
    #spreading fire command
    netlogo.command('Setup_spreadingFire')
    netlogo.repeat_command('Go',100)

if method ==2:
    ##EDITING SECTIONS
    dataFile =open("Forest Fire_v1.nlogo" , "r")
    list_of_lines = dataFile.readlines()
    print("which field you want to change?")
    print("---------------------------------")
    print("1.number tree-"+str(list_of_lines[224])+"\n"+"2.fire strength-"+str((list_of_lines[239]))+"\n"+"3.fire radius-"+str(list_of_lines[307])+"\n"+"4.wind ON/OFF(y/n)-"+str(list_of_lines[368])+"\n"
    +"5.wind direction-"+str(list_of_lines[355])+"\n6.rain ON/OFF(y/n)-"+str(list_of_lines[379])+"\n7.rain rate-"+str(list_of_lines[392])+"\n"+"8.spread probibility-"+str(list_of_lines[418])+"\n"+"9.big jumps ON/OFF-"+str(list_of_lines[431]))
    print("----------------------------------")
    print("%%%%%%% PLEASE NOTE ! 0=YES 1=NO %%%%%%%")
    print("Press Q/q to quit edditing ")
    print("**********************************")
    edit_choice = input("\nenter the field to change:")
    edit_value  = input("enter the value field:")
    while edit_choice != "q":
        if edit_choice =="1":
            print("previous value of number trees is:"+str(list_of_lines[224]))
            edit_value=str(edit_value)+"\n"
            list_of_lines[224]=edit_value
            print("the edited value of number trees is:"+str(list_of_lines[224]))
        if edit_choice =="2":
            print("previous value of fire strength is:"+str(list_of_lines[239]))
            edit_value=str(edit_value)+"\n"
            list_of_lines[239]=edit_value
        if edit_choice =="3":
            print("previous value of fire radius is:"+str(list_of_lines[307]))
            edit_value=str(edit_value)+"\n"
            list_of_lines[307]=edit_value        
        if edit_choice =="4":
            if edit_value =="y":
                edit_value ="0"
            if edit_value =="n":
                edit_value ="1"
            edit_value=str(edit_value)+"\n"
            list_of_lines[368]=edit_value            
        if edit_choice =="5":
            print("previous value of wind direction is:"+str(list_of_lines[355]))
            edit_value=str(edit_value)+"\n"
            list_of_lines[355]=edit_value
        if edit_choice =="6":       
            if edit_value =="y":
                edit_value ="0"
            if edit_value =="n":
                edit_value ="1"            
            edit_value=str(edit_value)+"\n"
            list_of_lines[379]=edit_value            
        if edit_choice =="7":
            print("previous value of rain rate is:"+str(list_of_lines[392]))
            edit_value=str(edit_value)+"\n"
            list_of_lines[392]=edit_value  
        if edit_choice =="8":
            print("previous value of spread probibility is:"+str(list_of_lines[418]))
            edit_value=str(edit_value)+"\n"
            list_of_lines[418]=edit_value                      
        if edit_choice =="9":
            print("previous value of big jumps is:"+str(list_of_lines[431]))
            edit_value=str(edit_value)+"\n"
            list_of_lines[431]=edit_value            
        edit_choice = input("\nenter the field to change:")
        edit_value  = input("enter the value field:")    
    dataFile=open("Forest Fire_v1.nlogo","w")
    dataFile.writelines(list_of_lines)
    dataFile.close()
    
    netlogo = pyNetLogo.NetLogoLink(gui=True) # shows netlogo
    netlogo.load_model(r'Forest Fire_v1.nlogo') # laods the netlogo project
    #spreading fire command
    netlogo.command('Setup_spreadingFire')
    netlogo.repeat_command('Go',100)
    layout = [[sg.Text("----NETLOGO CONTROLLER SUMMARY GUI----")],
        [sg.Text("*** 0=Yes 1=No ***")],
        [sg.Text('Number Of Trees',size=(15,1)),sg.InputText(list_of_lines[224],disabled=True)],
        [sg.Text('Fire Strength',size=(15,1)),sg.InputText(list_of_lines[239],disabled=True)],
        [sg.Text('Fire Radius',size=(15,1)),sg.InputText(list_of_lines[307],disabled=True)],
        [sg.Text('Wind On/Off',size=(15,1)),sg.InputText(list_of_lines[368],disabled=True)],
        [sg.Text('Wind Direction',size=(15,1)),sg.InputText(list_of_lines[355],disabled=True)],
        [sg.Text('Rain On/Off',size=(15,1)),sg.InputText(list_of_lines[379],disabled=True)],
        [sg.Text('Rain Rate',size=(15,1)),sg.InputText(list_of_lines[392],disabled=True)],
        [sg.Text('Spread Probibility',size=(15,1)),sg.InputText(list_of_lines[418],disabled=True)],
        [sg.Text('Big Jumps',size=(15,1)),sg.InputText(list_of_lines[431],disabled=True)],
        [sg.Button("EXIT")]
    ]

    # Create the window
    window = sg.Window("NetlogoController", layout)

    # Create an event loop
    while True:
        event, values = window.read()
        # End program if user closes window or
        # presses the OK button
        if event == "EXIT" or event == sg.WIN_CLOSED:
            break
    window.close()    
if method != 2 and method !=1:
    print("invalid input")