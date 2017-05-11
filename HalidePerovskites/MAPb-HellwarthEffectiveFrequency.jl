# HellwarthEffectiveFrequency.jl 
#   - use Hellwarth et al. 1999 PRB method to reduce multiple phonon modes to a single effective frequency

push!(LOAD_PATH,"../src/") # load module from local directory
using FeynmanKadanoffOsakaHellwarth

# ((freq THz)) ((IR Activity / e^2 amu^-1))
# These data from MAPbI3-Cubic_PeakTable.csv
# https://github.com/WMD-group/Phonons/tree/master/2015_MAPbI3/SimulatedSpectra
# Data published in Brivio2015 (PRB)
# https://doi.org/10.1103/PhysRevB.92.144308
MAPI= [
96.20813558773261 0.4996300522819191
93.13630357703363 1.7139631746083817
92.87834578121567 0.60108592692181
92.4847918585963 0.0058228799414729
92.26701437594754 0.100590086574602
89.43972834606603 0.006278895133832249
46.89209141511332 0.2460894564364346
46.420949316788 0.14174282581124137
44.0380222871706 0.1987196948553428
42.89702947649343 0.011159939465770681
42.67180170168193 0.02557751102757614
41.46971205834201 0.012555230726601503
37.08982543385215 0.00107488277468418
36.53555265689563 0.02126940080871224
30.20608114002676 0.009019481779712388
27.374810898415028 0.03994453721421388
26.363055017011728 0.05011922682554448
9.522966890022039 0.00075631870522737
4.016471586720514 0.08168931020200264
3.887605410774121 0.006311654262282101
3.5313112232401513 0.05353548710183397
2.755392921480459 0.021303020776321225
2.4380741812443247 0.23162784335484837
2.2490917637719408 0.2622203718355982
2.079632190634424 0.23382298607799906
2.0336707697261187 0.0623239656843172
1.5673011873879714 0.0367465760261409
1.0188379384951798 0.0126328938653956
1.0022960504442775 0.006817361620021601
0.9970130778462072 0.0103757951973341
0.9201781906386209 0.01095811116040592
0.800604081794174 0.0016830270365341532
0.5738689505255512 0.00646428491253749
#0.022939578929507105 8.355742795827834e-05   # Acoustic modes!
#0.04882611767873102 8.309858592685e-06
#0.07575149723846182 2.778248540373041e-05
]

# Change to SI, but not actually needed as units cancel everywhere

#MAPI_SI = [ MAPI_orig[:,1].*10^12*2*π MAPI_orig[:,2].*1 ]

# OK, black magic here - perhaps our units of oscillator strength are not what we need? maybe already effectively 'squared'?
#MAPI = [ MAPI[:,1] MAPI[:,2].^0.5]

MAPI_low=MAPI[19:33,:] # Just inorganic components, everything below 10THz; modes 3-18

MAPbBr3 = [
#v / THz IR Activity / e^2 amu^-1
96.25494581101505 0.4856105419754306
93.36827101597564 1.5237045178260684
93.19828072025739 0.54951133126244
92.59570097621418 0.0017497942636829
92.36075758752216 0.054483693922451705
89.49998024367731 0.003950754031148851
47.175408954380885 0.21156964115237242
46.57576693654983 0.11627478349663156
44.3361503231313 0.19163912283684897
42.967352451897554 0.011987727827091217
42.71066583604171 0.027797225985699996
41.490751582679316 0.01234463397562453
37.22033177431264 0.001649578352399309
36.57010484641483 0.019161684306162618
30.438999700507342 0.007365167772350685
27.625465570185764 0.035161502048866464
26.458785163031635 0.038174133532805965
9.947074760143552 0.0012355225072173002
4.493935108724231 0.07714630445769342
4.215763207131703 0.01724042408702847
4.021795301113039 0.06167913225780508
3.2393471899404047 0.040335730459227545
2.914057478007975 0.27361583921530497
2.6223962950449407 0.23493646364819373
2.400751729577614 0.2753271857365242
2.370809478597967 0.04428317547154772
2.0388405406936783 0.0517120158657721
1.4017373572275915 0.0046510016948825
1.3634089519825427 0.0018248126743814707
1.336413930635821 0.009190430969212338
1.2144969737450764 0.013885351107636132
1.0763905048534899 0.0014676450708402083
0.7427782546143306 0.008829646844819504
#0.012830037764855392 6.62960832415985e-06
#0.02156203260482768 4.708045983230229e-05
#0.05156888885824344 2.602755859934495e-05
]

MAPbCl3= [
#v / THz IR Activity / e^2 amu^-1
96.65380905798915 0.4542931751264273
93.30434573145013 1.4046841552487999
93.27126600254645 0.5286008698609284
92.719992888923 0.0015896642905404556
92.45885414527524 0.0866990370170258
89.61967951587117 0.0031392395308660263
47.44029120639781 0.18901278025443116
46.764089990499585 0.09717407330258415
44.60198174803584 0.19436643102794884
43.04971569182655 0.012986533289171532
42.7637228646608 0.02998334671150052
41.49924134521671 0.010714577213688365
37.34275112339727 0.0028788161278648656
36.62941263763097 0.018016387094969555
30.651112964494686 0.006550727272302003
27.89469865012452 0.03515737503204058
26.603746656189923 0.03497660426639104
10.493140658721968 9.69032373922839e-05
5.242459815070028 0.12301715153349158
4.8348539006445845 0.11307729502447525
4.633936235943856 0.009371996258413128
4.1582548301810665 0.08368265471427451
3.9021555976797266 0.44406366947684967
3.3808364269416287 0.3379317982808455
3.099250159114845 0.38405867852912545
2.8466202448045217 0.025463767673713028
2.5900539956188333 0.07754012506771049
2.0931563078880493 0.008533555182635471
1.869999049657922 0.011347668353507898
1.8382471614901006 0.0005371757988
1.829843559303894 0.019270325513936128
1.6503257694697964 0.000950380841742176
1.0962868606064022 0.018510433944796113
#0.032159306112378404 2.774125107895896e-05 #Acoustic
#0.04846756590412458 7.796048392205337e-05
#0.05253089286287104 2.8730156133e-06
]

println("\n\nMAPI: BScheme (athermal)")
println("\t MAPI: (all values)")
HellwarthBScheme(MAPI)
println("\t MAPI: (low-frequency, non molecular IR, only)")
HellwarthBScheme(MAPI_low)

println("\nMAPI: AScheme (thermal)")
println("\t MAPI: (all values)")
HellwarthAScheme(MAPI)
println("\t MAPI: (low-frequency, non molecular IR)")
HellwarthAScheme(MAPI_low)

for LOs in [MAPI, MAPbBr3, MAPbCl3]
   HellwarthBScheme(LOs)
   HellwarthBScheme(LOs[19:33,:])
end

println("\n Test summation of Lorentz oscillators to get to static dielectric constant from i.r. modes.")
# Integrate through Lorentz oscillators to get dielectric fn
# Should give 'extra' contribution from these modes, extrapolated to zero omega
function integrate_dielectric(LO,V0)
    summate=sum( (LO[:,2])./(LO[:,1].^2) )
#    summate*4*π/V0
    summate*ε0/V0
end

const Å=1E-10 # angstrom in metres
const r=6.29Å # Sensible cubic cell size
const V0=(r)^3
println("volume: $V0")
const amu=1.66054e-27
const ε0=8.854187817E-12
const eV = const q = const ElectronVolt = 1.602176487e-19;                         # kg m2 / s2 

MAPI_SI = [ MAPI[:,1].*10^12*2*π MAPI[:,2]./(q^2/amu) ]

println(" MAPI: ",integrate_dielectric(MAPI,1.0))
println(" MAPI_low: ",integrate_dielectric(MAPI_low,1.0))
println(" MAPI_SI: ",integrate_dielectric(MAPI_SI,V0))
println(" MAPI_SI: fudged epislon0 ",integrate_dielectric(MAPI_SI,V0)*ε0/(4*π))
println(" MAPI_SI_low: fudged epislon0 ",integrate_dielectric(MAPI_SI[19:33,:],V0)*ε0/(4*π))


println()
#println("From ε_S-ε_Inf, expect this to be: ",ε_S-ε_Inf)

