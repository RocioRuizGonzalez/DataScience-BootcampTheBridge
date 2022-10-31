import streamlit as st
import pandas as pd
df=pd.read_csv("sevici.csv")


menu_lateral=st.sidebar.selectbox("MENU",["Datos","Visualizacion","Filtrado"])

if menu_lateral=="Datos":
    st.metric("Número total de bicis Sevici en Sevilla",df["capacity"].sum(),20)
    df

elif menu_lateral=="Visualizacion":
    st.map(df)

elif menu_lateral=="Filtrado":
    menu_radio_ls=["Calle","Capacidad & distrito"]
    menu_radio = st.sidebar.radio("Seleccione una opción de filtro", menu_radio_ls)
    if menu_radio=="Calle": 
        calles=list(df["name"].unique())
        menu_calles=st.sidebar.selectbox("calles",options=calles)
        df=df[df["name"]== menu_calles]
        st.dataframe(df)
        st.map(df[["lon","lat"]],use_container_width=False)
    elif menu_radio=="Capacidad & distrito":
        menu_capacidades = st.sidebar.radio("Capacidades",["<20",">=20"])
        menu_distritos=st.sidebar.radio("Distritos",sorted(list(df.distrito.unique())))
        if menu_capacidades == "<20":
            df=df[(df["capacity"]<20)& (df["distrito"]== menu_distritos)]
            st.map(df[["lon","lat"]],use_container_width=False)
            st.dataframe(df)
        else:
            df=df[(df["capacity"]>=20)& (df["distrito"]==menu_distritos)]
            st.map(df[["lon","lat"]],use_container_width=False)
        



    


