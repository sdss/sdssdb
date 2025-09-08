CREATE MATERIALIZED VIEW sandbox.rs_run_to_sdssid
AS
select assn.pk as assignment_pk, at.mjd, t.catalogid, c.program, c.carton,
i.label as instrument, i.default_lambda_eff, sdssid.sdss_id,
obs.label as observatory, at.status as done,
f.field_id
from targetdb.assignment_status as at
join targetdb.assignment as assn on assn.pk = at.assignment_pk
join targetdb.hole as hole on hole.pk = assn.hole_pk
join targetdb.observatory as obs on obs.pk = hole.observatory_pk
join targetdb.carton_to_target as c2t on c2t.pk = assn.carton_to_target_pk
join targetdb.target as t on c2t.target_pk = t.pk
join targetdb.carton as c on c.pk = c2t.carton_pk
join targetdb.instrument as i on i.pk = assn.instrument_pk
join catalogdb.sdss_id_flat as sdssid on sdssid.catalogid = t.catalogid
join targetdb.design_to_field as d2f on d2f.design_id = assn.design_id
join targetdb.field as f on f.pk = d2f.field_pk
join targetdb.version as v on v.pk = f.version_pk
where v.plan = 'iota-1';

CREATE MATERIALIZED VIEW sandbox.carton_to_sdssid
AS
select t.catalogid, c.program, c.carton, 
i.label as instrument,
i.default_lambda_eff, sdssid.sdss_id,
(select sum(n) from unnest(cad.nexp) as n) as nexp
from targetdb.carton_to_target as c2t 
join targetdb.target as t on c2t.target_pk = t.pk
join targetdb.carton as c on c.pk = c2t.carton_pk
join targetdb.cadence as cad on cad.pk = c2t.cadence_pk
join targetdb.instrument as i on i.pk = c2t.instrument_pk
join catalogdb.sdss_id_flat as sdssid on sdssid.catalogid = t.catalogid
where c.pk in 
(1516, 1515, 1517, 1508, 1509, 1510, 1721, 1511, 1722, 1555, 
1818, 1499, 1498, 1717, 1501, 1500, 1726, 1505, 1719, 1504, 
1727, 1503, 1729, 1507, 1720, 1506, 1728, 1502, 1718, 1525, 
1526, 1527, 1662, 1663, 1528, 1529, 1800, 1530, 1531, 1801, 
1532, 1533, 1802, 1534, 1535, 1803, 1536, 1537, 1804, 1538, 
1539, 1805, 1540, 1541, 1806, 1367, 1368, 1369, 1632, 1633, 
1659, 1647, 1648, 1649, 1667, 1651, 1652, 1653, 1668, 
1660, 1554, 1556, 1557, 1558, 1559, 1634, 1624, 1625, 1665, 
1666, 1402, 1403, 1566, 1569, 1568, 1567, 1661, 1570, 
1799, 1626, 1627, 1636, 1637, 1619, 1620, 1622, 1621, 1631, 
1595, 1723, 1725, 1594, 1810, 1811, 1573, 1572, 1734, 
1590, 1586, 1759, 1591, 1587, 1760, 1592, 1588, 1761, 1593, 
1589, 1762, 1584, 1578, 1739, 1581, 1597, 1736, 1585, 
1579, 1740, 1582, 1576, 1737, 1583, 1577, 1738, 1580, 1574, 
1735, 1638, 1657, 1658, 1565, 1561, 1562, 1378, 1732, 
1807, 1813, 1809, 1599, 1601, 1598, 1600, 1644, 1645, 1772, 
1778, 1777, 1776, 1771, 1775, 1774, 1773, 1267, 1469, 
1268, 1470, 1273, 1468, 1271, 1462, 1272, 1463, 1276, 1464, 
1308, 1465, 1412, 1471, 1278, 1472, 1279, 1473, 1280, 
1474, 1274, 1466, 1275, 1467, 1320, 1321, 1289, 1322, 1323, 
1324, 1290, 1325, 1326, 1291, 1292, 1344, 1327, 1328, 
1293, 1329, 1358, 1330, 1331, 1332, 1333, 1334, 1335, 1336, 
1337, 1338, 1339, 1340, 1707, 1698, 1694, 1695, 1669, 
1670, 1671, 1672, 1673, 1674, 1675, 1676, 1677, 1678, 1692, 
1679, 1690, 1691, 1680, 1681, 1682, 1683, 1684, 1685, 
1686, 1687, 1816, 1817, 1699, 1700, 1814, 1815, 1704, 1708, 
1714, 1709, 1712, 1711, 1701, 1702, 1097, 1098, 1095, 
1108, 1096, 1371, 1374, 1370, 1263, 1475, 1375, 1376, 1372,
1821, 1822, 1823, 1824, 1825, 1826, 1827, 1828, 1829, 1830,
1831, 1832, 1833, 1834, 1839, 1848, 1849, 1850, 1851, 1852,
1853, 1854, 1856, 1860, 1861, 1862, 1863,
1116, 1642, 1639, 1640, 1641, 1643, 696, 693, 694, 704, 705, 
706, 709, 707, 708, 1343, 1043, 1044, 1132, 1133, 537, 538, 
632, 633, 547, 548, 715, 1424, 803, 772, 1514, 1409, 1628, 
1411, 1487, 1486, 1130, 1131, 552, 1104, 586, 637, 585, 750, 
751, 1001, 1002, 1007, 1040, 1041, 1042, 1011, 1015, 1016, 
1021, 1023, 1027, 1028, 1029);

-- TO DO: use Tom's targeting generation table once it's on pipelines
