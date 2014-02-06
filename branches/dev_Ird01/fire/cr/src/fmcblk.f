      BLOCK DATA FMCBLK
      IMPLICIT NONE
C----------
C   **FMCBLK--FIRE-CR  DATE OF LAST REVISION:   06/18/09
C----------
COMMONS
C
      INCLUDE 'PRGPRM.F77'
      INCLUDE 'FMPROP.F77'

      INTEGER J

C     GROUPING FOR THE JENKINS BIOMASS EQUATIONS FOR C REPORTING
C     SOFTWOODS
C       1=CEDAR/LARCH
C       2=DOUGLAS-FIR
C       3=TRUE FIR/HEMLOCK
C       4=PINE
C       5=SPRUCE
C     HARDWOODS
C       6=ASPEN/ALDER/COTTONWOOD/WILLOW
C       7=SOFT MAPLE/BIRCH
C       8=MIXED HARDWOOD
C       9=HARD MAPLE/OAK/HICKORY/BEECH
C      10=WOODLAND JUNIPER/OAK/MESQUITE

      DATA BIOGRP/
     >  3,  3,  2,  3,  3,  3,  1,  1,  4,  4,
     >  4,  4,  4,  4,  4, 10,  5,  5,  5,  6,
     >  6,  6, 10, 10, 10, 10, 10,  6, 10, 10,
     > 10, 10,  4,  4,  4,  4,  4,  6/

C DATA Statement Debug Information
C         Variant   = CR
C        Interval   = 1 yrs
C      Field tags   = RM;sw;all
C SubRegion index I = 1
C  DataType index K = 1 (1=InUse; 2=Landfill; 3=Energy)
C  Pulp/Saw index M = 1 (1=Pulp;  2=Saw)
C     Sw/Hw index N = 1 (1=Soft;  2=Hard)

      DATA (FAPROP(1,J,1,1,1), J= 1,101) /
     & 0.7043,0.6639,0.6277,0.5954,0.5665,0.5406,0.5167,0.4949,0.4743,
     & 0.4552,0.4377,0.4221,0.4081,0.3954,0.3839,0.3733,0.3636,0.3545,
     & 0.3460,0.3378,0.3301,0.3229,0.3161,0.3096,0.3034,0.2974,0.2917,
     & 0.2862,0.2809,0.2758,0.2708,0.2660,0.2614,0.2569,0.2526,0.2484,
     & 0.2443,0.2404,0.2366,0.2328,0.2292,0.2257,0.2223,0.2190,0.2158,
     & 0.2126,0.2096,0.2066,0.2037,0.2009,0.1981,0.1954,0.1928,0.1902,
     & 0.1877,0.1852,0.1828,0.1805,0.1782,0.1759,0.1738,0.1716,0.1695,
     & 0.1674,0.1654,0.1634,0.1615,0.1596,0.1577,0.1559,0.1541,0.1523,
     & 0.1506,0.1489,0.1472,0.1456,0.1440,0.1424,0.1408,0.1393,0.1378,
     & 0.1363,0.1348,0.1334,0.1320,0.1306,0.1292,0.1279,0.1266,0.1253,
     & 0.1240,0.1227,0.1215,0.1202,0.1190,0.1178,0.1167,0.1155,0.1144,
     & 0.1132,0.1121/

C DATA Statement Debug Information
C         Variant   = CR
C        Interval   = 1 yrs
C      Field tags   = RM;sw;all
C SubRegion index I = 1
C  DataType index K = 2 (1=InUse; 2=Landfill; 3=Energy)
C  Pulp/Saw index M = 1 (1=Pulp;  2=Saw)
C     Sw/Hw index N = 1 (1=Soft;  2=Hard)

      DATA (FAPROP(1,J,2,1,1), J= 1,101) /
     & 0.0000,0.0189,0.0359,0.0511,0.0646,0.0768,0.0879,0.0980,0.1073,
     & 0.1160,0.1237,0.1307,0.1370,0.1426,0.1477,0.1524,0.1567,0.1607,
     & 0.1643,0.1678,0.1711,0.1741,0.1769,0.1796,0.1822,0.1846,0.1869,
     & 0.1891,0.1911,0.1931,0.1951,0.1969,0.1987,0.2004,0.2020,0.2036,
     & 0.2051,0.2065,0.2080,0.2093,0.2107,0.2119,0.2132,0.2144,0.2156,
     & 0.2167,0.2178,0.2189,0.2199,0.2210,0.2220,0.2229,0.2239,0.2248,
     & 0.2257,0.2266,0.2275,0.2283,0.2292,0.2300,0.2308,0.2316,0.2324,
     & 0.2331,0.2339,0.2346,0.2354,0.2361,0.2368,0.2375,0.2382,0.2388,
     & 0.2395,0.2401,0.2408,0.2414,0.2420,0.2427,0.2433,0.2439,0.2445,
     & 0.2451,0.2456,0.2462,0.2468,0.2473,0.2479,0.2484,0.2490,0.2495,
     & 0.2500,0.2505,0.2510,0.2515,0.2520,0.2525,0.2530,0.2535,0.2540,
     & 0.2545,0.2549/

C DATA Statement Debug Information
C         Variant   = CR
C        Interval   = 1 yrs
C      Field tags   = RM;sw;all
C SubRegion index I = 1
C  DataType index K = 3 (1=InUse; 2=Landfill; 3=Energy)
C  Pulp/Saw index M = 1 (1=Pulp;  2=Saw)
C     Sw/Hw index N = 1 (1=Soft;  2=Hard)

      DATA (FAPROP(1,J,3,1,1), J= 1,101) /
     & 0.2091,0.2229,0.2354,0.2465,0.2564,0.2651,0.2732,0.2805,0.2874,
     & 0.2939,0.2997,0.3049,0.3095,0.3135,0.3171,0.3204,0.3233,0.3261,
     & 0.3286,0.3311,0.3333,0.3354,0.3374,0.3392,0.3410,0.3427,0.3443,
     & 0.3458,0.3473,0.3486,0.3500,0.3513,0.3525,0.3536,0.3547,0.3558,
     & 0.3568,0.3578,0.3587,0.3596,0.3605,0.3613,0.3620,0.3628,0.3635,
     & 0.3641,0.3648,0.3654,0.3659,0.3665,0.3670,0.3675,0.3680,0.3684,
     & 0.3688,0.3692,0.3696,0.3699,0.3703,0.3706,0.3708,0.3711,0.3714,
     & 0.3716,0.3718,0.3720,0.3722,0.3724,0.3725,0.3727,0.3728,0.3729,
     & 0.3730,0.3731,0.3732,0.3732,0.3733,0.3733,0.3734,0.3734,0.3734,
     & 0.3734,0.3734,0.3734,0.3734,0.3734,0.3734,0.3734,0.3734,0.3734,
     & 0.3734,0.3734,0.3734,0.3734,0.3734,0.3734,0.3734,0.3734,0.3734,
     & 0.3734,0.3734/

C DATA Statement Debug Information
C         Variant   = CR
C        Interval   = 1 yrs
C      Field tags   = RM;sw;all
C SubRegion index I = 1
C  DataType index K = 1 (1=InUse; 2=Landfill; 3=Energy)
C  Pulp/Saw index M = 2 (1=Pulp;  2=Saw)
C     Sw/Hw index N = 1 (1=Soft;  2=Hard)

      DATA (FAPROP(1,J,1,2,1), J= 1,101) /
     & 0.7043,0.6639,0.6277,0.5954,0.5665,0.5406,0.5167,0.4949,0.4743,
     & 0.4552,0.4377,0.4221,0.4081,0.3954,0.3839,0.3733,0.3636,0.3545,
     & 0.3460,0.3378,0.3301,0.3229,0.3161,0.3096,0.3034,0.2974,0.2917,
     & 0.2862,0.2809,0.2758,0.2708,0.2660,0.2614,0.2569,0.2526,0.2484,
     & 0.2443,0.2404,0.2366,0.2328,0.2292,0.2257,0.2223,0.2190,0.2158,
     & 0.2126,0.2096,0.2066,0.2037,0.2009,0.1981,0.1954,0.1928,0.1902,
     & 0.1877,0.1852,0.1828,0.1805,0.1782,0.1759,0.1738,0.1716,0.1695,
     & 0.1674,0.1654,0.1634,0.1615,0.1596,0.1577,0.1559,0.1541,0.1523,
     & 0.1506,0.1489,0.1472,0.1456,0.1440,0.1424,0.1408,0.1393,0.1378,
     & 0.1363,0.1348,0.1334,0.1320,0.1306,0.1292,0.1279,0.1266,0.1253,
     & 0.1240,0.1227,0.1215,0.1202,0.1190,0.1178,0.1167,0.1155,0.1144,
     & 0.1132,0.1121/

C DATA Statement Debug Information
C         Variant   = CR
C        Interval   = 1 yrs
C      Field tags   = RM;sw;all
C SubRegion index I = 1
C  DataType index K = 2 (1=InUse; 2=Landfill; 3=Energy)
C  Pulp/Saw index M = 2 (1=Pulp;  2=Saw)
C     Sw/Hw index N = 1 (1=Soft;  2=Hard)

      DATA (FAPROP(1,J,2,2,1), J= 1,101) /
     & 0.0000,0.0189,0.0359,0.0511,0.0646,0.0768,0.0879,0.0980,0.1073,
     & 0.1160,0.1237,0.1307,0.1370,0.1426,0.1477,0.1524,0.1567,0.1607,
     & 0.1643,0.1678,0.1711,0.1741,0.1769,0.1796,0.1822,0.1846,0.1869,
     & 0.1891,0.1911,0.1931,0.1951,0.1969,0.1987,0.2004,0.2020,0.2036,
     & 0.2051,0.2065,0.2080,0.2093,0.2107,0.2119,0.2132,0.2144,0.2156,
     & 0.2167,0.2178,0.2189,0.2199,0.2210,0.2220,0.2229,0.2239,0.2248,
     & 0.2257,0.2266,0.2275,0.2283,0.2292,0.2300,0.2308,0.2316,0.2324,
     & 0.2331,0.2339,0.2346,0.2354,0.2361,0.2368,0.2375,0.2382,0.2388,
     & 0.2395,0.2401,0.2408,0.2414,0.2420,0.2427,0.2433,0.2439,0.2445,
     & 0.2451,0.2456,0.2462,0.2468,0.2473,0.2479,0.2484,0.2490,0.2495,
     & 0.2500,0.2505,0.2510,0.2515,0.2520,0.2525,0.2530,0.2535,0.2540,
     & 0.2545,0.2549/

C DATA Statement Debug Information
C         Variant   = CR
C        Interval   = 1 yrs
C      Field tags   = RM;sw;all
C SubRegion index I = 1
C  DataType index K = 3 (1=InUse; 2=Landfill; 3=Energy)
C  Pulp/Saw index M = 2 (1=Pulp;  2=Saw)
C     Sw/Hw index N = 1 (1=Soft;  2=Hard)

      DATA (FAPROP(1,J,3,2,1), J= 1,101) /
     & 0.2091,0.2229,0.2354,0.2465,0.2564,0.2651,0.2732,0.2805,0.2874,
     & 0.2939,0.2997,0.3049,0.3095,0.3135,0.3171,0.3204,0.3233,0.3261,
     & 0.3286,0.3311,0.3333,0.3354,0.3374,0.3392,0.3410,0.3427,0.3443,
     & 0.3458,0.3473,0.3486,0.3500,0.3513,0.3525,0.3536,0.3547,0.3558,
     & 0.3568,0.3578,0.3587,0.3596,0.3605,0.3613,0.3620,0.3628,0.3635,
     & 0.3641,0.3648,0.3654,0.3659,0.3665,0.3670,0.3675,0.3680,0.3684,
     & 0.3688,0.3692,0.3696,0.3699,0.3703,0.3706,0.3708,0.3711,0.3714,
     & 0.3716,0.3718,0.3720,0.3722,0.3724,0.3725,0.3727,0.3728,0.3729,
     & 0.3730,0.3731,0.3732,0.3732,0.3733,0.3733,0.3734,0.3734,0.3734,
     & 0.3734,0.3734,0.3734,0.3734,0.3734,0.3734,0.3734,0.3734,0.3734,
     & 0.3734,0.3734,0.3734,0.3734,0.3734,0.3734,0.3734,0.3734,0.3734,
     & 0.3734,0.3734/

C DATA Statement Debug Information
C         Variant   = CR
C        Interval   = 1 yrs
C      Field tags   = W;hw;all
C SubRegion index I = 1
C  DataType index K = 1 (1=InUse; 2=Landfill; 3=Energy)
C  Pulp/Saw index M = 1 (1=Pulp;  2=Saw)
C     Sw/Hw index N = 2 (1=Soft;  2=Hard)

      DATA (FAPROP(1,J,1,1,2), J= 1,101) /
     & 0.5676,0.5288,0.4945,0.4639,0.4366,0.4122,0.3897,0.3691,0.3498,
     & 0.3319,0.3156,0.3010,0.2879,0.2762,0.2656,0.2559,0.2470,0.2387,
     & 0.2310,0.2236,0.2167,0.2103,0.2042,0.1984,0.1930,0.1877,0.1827,
     & 0.1779,0.1733,0.1689,0.1646,0.1605,0.1566,0.1528,0.1491,0.1456,
     & 0.1422,0.1390,0.1358,0.1328,0.1298,0.1270,0.1242,0.1215,0.1190,
     & 0.1165,0.1140,0.1117,0.1094,0.1072,0.1051,0.1030,0.1010,0.0991,
     & 0.0972,0.0953,0.0935,0.0918,0.0901,0.0885,0.0869,0.0853,0.0838,
     & 0.0823,0.0809,0.0795,0.0781,0.0768,0.0755,0.0742,0.0730,0.0718,
     & 0.0706,0.0695,0.0683,0.0673,0.0662,0.0651,0.0641,0.0631,0.0621,
     & 0.0612,0.0603,0.0594,0.0585,0.0576,0.0567,0.0559,0.0551,0.0543,
     & 0.0535,0.0527,0.0520,0.0512,0.0505,0.0498,0.0491,0.0484,0.0478,
     & 0.0471,0.0465/

C DATA Statement Debug Information
C         Variant   = CR
C        Interval   = 1 yrs
C      Field tags   = W;hw;all
C SubRegion index I = 1
C  DataType index K = 2 (1=InUse; 2=Landfill; 3=Energy)
C  Pulp/Saw index M = 1 (1=Pulp;  2=Saw)
C     Sw/Hw index N = 2 (1=Soft;  2=Hard)

      DATA (FAPROP(1,J,2,1,2), J= 1,101) /
     & 0.0000,0.0181,0.0342,0.0484,0.0612,0.0726,0.0830,0.0924,0.1011,
     & 0.1091,0.1163,0.1228,0.1285,0.1337,0.1383,0.1425,0.1464,0.1499,
     & 0.1532,0.1563,0.1591,0.1617,0.1642,0.1665,0.1687,0.1707,0.1726,
     & 0.1745,0.1762,0.1778,0.1794,0.1809,0.1823,0.1836,0.1849,0.1861,
     & 0.1873,0.1884,0.1895,0.1905,0.1915,0.1925,0.1934,0.1943,0.1951,
     & 0.1959,0.1967,0.1975,0.1982,0.1989,0.1996,0.2002,0.2009,0.2015,
     & 0.2021,0.2027,0.2033,0.2038,0.2043,0.2049,0.2054,0.2059,0.2063,
     & 0.2068,0.2073,0.2077,0.2082,0.2086,0.2090,0.2094,0.2098,0.2102,
     & 0.2106,0.2110,0.2113,0.2117,0.2120,0.2124,0.2127,0.2131,0.2134,
     & 0.2137,0.2140,0.2144,0.2147,0.2150,0.2153,0.2155,0.2158,0.2161,
     & 0.2164,0.2167,0.2169,0.2172,0.2174,0.2177,0.2180,0.2182,0.2184,
     & 0.2187,0.2189/

C DATA Statement Debug Information
C         Variant   = CR
C        Interval   = 1 yrs
C      Field tags   = W;hw;all
C SubRegion index I = 1
C  DataType index K = 3 (1=InUse; 2=Landfill; 3=Energy)
C  Pulp/Saw index M = 1 (1=Pulp;  2=Saw)
C     Sw/Hw index N = 2 (1=Soft;  2=Hard)

      DATA (FAPROP(1,J,3,1,2), J= 1,101) /
     & 0.2559,0.2668,0.2768,0.2858,0.2938,0.3009,0.3075,0.3135,0.3193,
     & 0.3246,0.3295,0.3338,0.3377,0.3411,0.3442,0.3470,0.3495,0.3519,
     & 0.3541,0.3563,0.3583,0.3601,0.3619,0.3636,0.3651,0.3667,0.3681,
     & 0.3695,0.3709,0.3721,0.3734,0.3746,0.3757,0.3768,0.3779,0.3789,
     & 0.3799,0.3808,0.3817,0.3826,0.3834,0.3842,0.3850,0.3858,0.3865,
     & 0.3872,0.3878,0.3885,0.3891,0.3897,0.3902,0.3908,0.3913,0.3918,
     & 0.3923,0.3927,0.3932,0.3936,0.3940,0.3944,0.3948,0.3951,0.3955,
     & 0.3958,0.3961,0.3964,0.3967,0.3970,0.3972,0.3975,0.3977,0.3980,
     & 0.3982,0.3984,0.3986,0.3988,0.3990,0.3991,0.3993,0.3994,0.3996,
     & 0.3997,0.3998,0.4000,0.4001,0.4002,0.4003,0.4004,0.4005,0.4005,
     & 0.4006,0.4007,0.4008,0.4008,0.4009,0.4009,0.4010,0.4010,0.4010,
     & 0.4011,0.4011/

C DATA Statement Debug Information
C         Variant   = CR
C        Interval   = 1 yrs
C      Field tags   = W;hw;all
C SubRegion index I = 1
C  DataType index K = 1 (1=InUse; 2=Landfill; 3=Energy)
C  Pulp/Saw index M = 2 (1=Pulp;  2=Saw)
C     Sw/Hw index N = 2 (1=Soft;  2=Hard)

      DATA (FAPROP(1,J,1,2,2), J= 1,101) /
     & 0.5676,0.5288,0.4945,0.4639,0.4366,0.4122,0.3897,0.3691,0.3498,
     & 0.3319,0.3156,0.3010,0.2879,0.2762,0.2656,0.2559,0.2470,0.2387,
     & 0.2310,0.2236,0.2167,0.2103,0.2042,0.1984,0.1930,0.1877,0.1827,
     & 0.1779,0.1733,0.1689,0.1646,0.1605,0.1566,0.1528,0.1491,0.1456,
     & 0.1422,0.1390,0.1358,0.1328,0.1298,0.1270,0.1242,0.1215,0.1190,
     & 0.1165,0.1140,0.1117,0.1094,0.1072,0.1051,0.1030,0.1010,0.0991,
     & 0.0972,0.0953,0.0935,0.0918,0.0901,0.0885,0.0869,0.0853,0.0838,
     & 0.0823,0.0809,0.0795,0.0781,0.0768,0.0755,0.0742,0.0730,0.0718,
     & 0.0706,0.0695,0.0683,0.0673,0.0662,0.0651,0.0641,0.0631,0.0621,
     & 0.0612,0.0603,0.0594,0.0585,0.0576,0.0567,0.0559,0.0551,0.0543,
     & 0.0535,0.0527,0.0520,0.0512,0.0505,0.0498,0.0491,0.0484,0.0478,
     & 0.0471,0.0465/

C DATA Statement Debug Information
C         Variant   = CR
C        Interval   = 1 yrs
C      Field tags   = W;hw;all
C SubRegion index I = 1
C  DataType index K = 2 (1=InUse; 2=Landfill; 3=Energy)
C  Pulp/Saw index M = 2 (1=Pulp;  2=Saw)
C     Sw/Hw index N = 2 (1=Soft;  2=Hard)

      DATA (FAPROP(1,J,2,2,2), J= 1,101) /
     & 0.0000,0.0181,0.0342,0.0484,0.0612,0.0726,0.0830,0.0924,0.1011,
     & 0.1091,0.1163,0.1228,0.1285,0.1337,0.1383,0.1425,0.1464,0.1499,
     & 0.1532,0.1563,0.1591,0.1617,0.1642,0.1665,0.1687,0.1707,0.1726,
     & 0.1745,0.1762,0.1778,0.1794,0.1809,0.1823,0.1836,0.1849,0.1861,
     & 0.1873,0.1884,0.1895,0.1905,0.1915,0.1925,0.1934,0.1943,0.1951,
     & 0.1959,0.1967,0.1975,0.1982,0.1989,0.1996,0.2002,0.2009,0.2015,
     & 0.2021,0.2027,0.2033,0.2038,0.2043,0.2049,0.2054,0.2059,0.2063,
     & 0.2068,0.2073,0.2077,0.2082,0.2086,0.2090,0.2094,0.2098,0.2102,
     & 0.2106,0.2110,0.2113,0.2117,0.2120,0.2124,0.2127,0.2131,0.2134,
     & 0.2137,0.2140,0.2144,0.2147,0.2150,0.2153,0.2155,0.2158,0.2161,
     & 0.2164,0.2167,0.2169,0.2172,0.2174,0.2177,0.2180,0.2182,0.2184,
     & 0.2187,0.2189/

C DATA Statement Debug Information
C         Variant   = CR
C        Interval   = 1 yrs
C      Field tags   = W;hw;all
C SubRegion index I = 1
C  DataType index K = 3 (1=InUse; 2=Landfill; 3=Energy)
C  Pulp/Saw index M = 2 (1=Pulp;  2=Saw)
C     Sw/Hw index N = 2 (1=Soft;  2=Hard)

      DATA (FAPROP(1,J,3,2,2), J= 1,101) /
     & 0.2559,0.2668,0.2768,0.2858,0.2938,0.3009,0.3075,0.3135,0.3193,
     & 0.3246,0.3295,0.3338,0.3377,0.3411,0.3442,0.3470,0.3495,0.3519,
     & 0.3541,0.3563,0.3583,0.3601,0.3619,0.3636,0.3651,0.3667,0.3681,
     & 0.3695,0.3709,0.3721,0.3734,0.3746,0.3757,0.3768,0.3779,0.3789,
     & 0.3799,0.3808,0.3817,0.3826,0.3834,0.3842,0.3850,0.3858,0.3865,
     & 0.3872,0.3878,0.3885,0.3891,0.3897,0.3902,0.3908,0.3913,0.3918,
     & 0.3923,0.3927,0.3932,0.3936,0.3940,0.3944,0.3948,0.3951,0.3955,
     & 0.3958,0.3961,0.3964,0.3967,0.3970,0.3972,0.3975,0.3977,0.3980,
     & 0.3982,0.3984,0.3986,0.3988,0.3990,0.3991,0.3993,0.3994,0.3996,
     & 0.3997,0.3998,0.4000,0.4001,0.4002,0.4003,0.4004,0.4005,0.4005,
     & 0.4006,0.4007,0.4008,0.4008,0.4009,0.4009,0.4010,0.4010,0.4010,
     & 0.4011,0.4011/

      END