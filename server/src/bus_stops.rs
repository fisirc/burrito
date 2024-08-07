use std::time::SystemTime;

use geo::{Centroid, Contains, GeodesicDistance, Polygon};
use geojson::{FeatureCollection, GeoJson};
use lazy_static::lazy_static;
use serde::{Deserialize, Serialize};


const BUS_STOPS_GEOJSON_STR: &str = r#"
{
    "type": "FeatureCollection",
    "features": [
        {
            "type": "Feature",
            "properties": {"name": "Paradero Clínica", "num": 7},
            "geometry": {
            "coordinates": [
                [
                [-77.08205968051753, -12.055591448899904],
                [-77.08201465109497, -12.055603279464037],
                [-77.08198328653116, -12.055598530496042],
                [-77.0819296946836, -12.055575693511244],
                [-77.08190144728509, -12.055544915940033],
                [-77.08189582528743, -12.055510693599288],
                [-77.08190476616896, -12.055466898208962],
                [-77.08194780315266, -12.05541059830621],
                [-77.08200454964043, -12.05536913372427],
                [-77.08207341848166, -12.055346190168933],
                [-77.08215040698421, -12.055348032116385],
                [-77.08219497255784, -12.055396064509821],
                [-77.08220253152476, -12.05544548979168],
                [-77.08220843204299, -12.055503310389511],
                [-77.0821739949611, -12.055556004884522],
                [-77.08211454191999, -12.05558920761024],
                [-77.08205968051753, -12.055591448899904]
                ]
            ],
            "type": "Polygon"
            },
            "id": 0
        },
        {
            "type": "Feature",
            "properties": {"name": "Paradero Puerta 2", "num": 5},
            "geometry": {
            "coordinates": [
                [
                [-77.07966175794014, -12.059754962436472],
                [-77.07958245751186, -12.059727621197268],
                [-77.07955633084185, -12.059672550710872],
                [-77.0795620489118, -12.05958141007099],
                [-77.07957856863105, -12.059488071272611],
                [-77.07961452915082, -12.059392990455265],
                [-77.07970264384701, -12.059375663042317],
                [-77.07977275115533, -12.05941183532137],
                [-77.07977894348814, -12.059504779367842],
                [-77.07977032762781, -12.059614223327173],
                [-77.07973841782909, -12.059716732672229],
                [-77.07966175794014, -12.059754962436472]
                ]
            ],
            "type": "Polygon"
            }
        },
        {
            "type": "Feature",
            "properties": {"num": 6, "name": "Paradero Puerta 3"},
            "geometry": {
            "coordinates": [
                [
                [-77.08006219985396, -12.057691210491626],
                [-77.08001641244864, -12.057671028307553],
                [-77.080005511545, -12.057608226336924],
                [-77.08001258224171, -12.057504320215997],
                [-77.08006850667101, -12.057407811042026],
                [-77.08015449132444, -12.057385628845012],
                [-77.08020459273074, -12.057398310702581],
                [-77.08024540987037, -12.057456469640158],
                [-77.08019521213464, -12.057622131686813],
                [-77.08014196656727, -12.05770172015022],
                [-77.08006219985396, -12.057691210491626]
                ]
            ],
            "type": "Polygon"
            },
            "id": 2
        },
        {
            "type": "Feature",
            "properties": {"name": "Paradero Odontología", "num": 1},
            "geometry": {
            "coordinates": [
                [
                [-77.0860081312461, -12.054929895537313],
                [-77.08596341046655, -12.054893314982138],
                [-77.08595582090645, -12.054825733709762],
                [-77.08597537644596, -12.054768224377398],
                [-77.08603272782744, -12.054736026765596],
                [-77.08609772299982, -12.05471605851352],
                [-77.08622699706623, -12.054744149146813],
                [-77.08627368225939, -12.054779323754758],
                [-77.08625721120836, -12.054894363597086],
                [-77.08622764161059, -12.054954615114525],
                [-77.08608341725507, -12.054963438745503],
                [-77.08601387829492, -12.05494609614459],
                [-77.0860081312461, -12.054929895537313]
                ]
            ],
            "type": "Polygon"
            }
        },
        {
            "type": "Feature",
            "properties": {"num": 2, "name": "Paradero Pedro Zulen"},
            "geometry": {
            "coordinates": [
                [
                [-77.0850640265494, -12.056367671369571],
                [-77.08499553995529, -12.056342876460619],
                [-77.08496993050387, -12.056259004304195],
                [-77.08495950399589, -12.056206281514264],
                [-77.08497901158995, -12.056142354434215],
                [-77.08502498973318, -12.056106040268375],
                [-77.08508312621161, -12.056103040295241],
                [-77.08516459961685, -12.056119310479545],
                [-77.085228845065, -12.05615395433297],
                [-77.08527484951192, -12.056193704611246],
                [-77.08529054256232, -12.056248924790367],
                [-77.0852923702423, -12.056299856215702],
                [-77.08528686243343, -12.056368525759197],
                [-77.0852638649929, -12.056395205567199],
                [-77.08518212283485, -12.056428727372264],
                [-77.08509010434207, -12.056384632832888],
                [-77.0850640265494, -12.056367671369571]
                ]
            ],
            "type": "Polygon"
            }
        },
        {
            "type": "Feature",
            "properties": {"name": "Paradero Puerta 7", "num": 8},
            "geometry": {
            "coordinates": [
                [
                [-77.08444383775037, -12.054374185784951],
                [-77.08435551960068, -12.054359509731142],
                [-77.0843066739437, -12.054331256712302],
                [-77.08427689230062, -12.054266783020438],
                [-77.08428979131139, -12.05418530737633],
                [-77.08434304488783, -12.05410994190244],
                [-77.08442392945545, -12.054045277963908],
                [-77.08453061449887, -12.0540197170522],
                [-77.08459790293753, -12.054032512532387],
                [-77.08464354042691, -12.054064190556588],
                [-77.08466972740543, -12.054117691425446],
                [-77.08466564669125, -12.054193984423094],
                [-77.08462962660671, -12.054261530656632],
                [-77.08455735878788, -12.05432228493207],
                [-77.08449363182943, -12.054354350206125],
                [-77.08444383775037, -12.054374185784951]
                ]
            ],
            "type": "Polygon"
            },
            "id": 6
        },
        {
            "type": "Feature",
            "properties": {"num": 3, "name": "Paradero Química"},
            "geometry": {
            "coordinates": [
                [
                [-77.08433944704797, -12.060433143749464],
                [-77.08428471435113, -12.060421079958417],
                [-77.08426209567246, -12.06037447151526],
                [-77.08426051327419, -12.060311285973967],
                [-77.0842861266115, -12.060230816472327],
                [-77.08432158684937, -12.060169462737619],
                [-77.08436774586553, -12.060146237566073],
                [-77.08443669701761, -12.060157936334335],
                [-77.08445977311304, -12.06019919786425],
                [-77.08448322247817, -12.06025436402281],
                [-77.08444307468108, -12.060361588003019],
                [-77.08440072849557, -12.060442041795397],
                [-77.08433944704797, -12.060433143749464]
                ]
            ],
            "type": "Polygon"
            }
        },
        {
            "type": "Feature",
            "properties": {"num": 4, "name": "Paradero del Comedor"},
            "geometry": {
            "coordinates": [
                [
                [-77.08292620387016, -12.060874615466446],
                [-77.0828245725424, -12.060857264607563],
                [-77.08277651340019, -12.06080582124656],
                [-77.08277331943646, -12.060756263448098],
                [-77.08278942482097, -12.060711590704656],
                [-77.08283169055069, -12.06067284183753],
                [-77.08292405783148, -12.06067897520353],
                [-77.0830514730582, -12.060705903128948],
                [-77.08310295287949, -12.060729401383966],
                [-77.08313201617818, -12.06077404267998],
                [-77.08312593360246, -12.060825140375485],
                [-77.08308977007098, -12.060869720561442],
                [-77.08301176054012, -12.060883684900347],
                [-77.08292620387016, -12.060874615466446]
                ]
            ],
            "type": "Polygon"
            }
        },
        {
            "type": "Feature",
            "properties": {"name": "Paradero Sistemas", "num": 9},
            "geometry": {
            "coordinates": [
                [
                    [-77.08571187676019, -12.053820809760538],
                    [-77.08564548274394, -12.053765642787639],
                    [-77.08562362061943, -12.053691439036882],
                    [-77.085634228674, -12.053628596546247],
                    [-77.08567978982245, -12.053569757419254],
                    [-77.08578845200537, -12.053541096190514],
                    [-77.08588364104544, -12.053568398797466],
                    [-77.08593200636724, -12.053629214363582],
                    [-77.08591630823227, -12.053732533305165],
                    [-77.08586846345983, -12.053797471492246],
                    [-77.08580441640552, -12.05382322069957],
                    [-77.08571187676019, -12.053820809760538]
                ]
            ],
            "type": "Polygon"
            },
            "id": 10
        }
    ]
}
"#;

// global variable to store the parsed geojson (read only)

lazy_static! {
    static ref BUS_STOPS: FeatureCollection = {
        let geo_json = BUS_STOPS_GEOJSON_STR.parse::<GeoJson>().unwrap();
        FeatureCollection::try_from(geo_json).unwrap()
    };
}

#[derive(Debug, Deserialize, Serialize, Clone)]
pub struct BusStopInfo {
    pub name: String,
    pub number: i32,
    pub has_reached: bool,
    pub timestamp: SystemTime,
    pub distance: f64,
}

fn feature_to_polygon(feature: &geojson::Feature) -> geo::Polygon {
    match feature.geometry.as_ref().map(|g| &g.value) {
        Some(geojson::Value::Polygon(p)) => {
            let points = p.first().unwrap().iter().map(|pair| geo::Coord { x: pair[0], y: pair[1] }).collect::<Vec<_>>();
            Polygon::new(geo::LineString::new(points), vec![])
        },
        _ => unreachable!(),
    }
}

// Given a point, it returns the bus stop (paradero) located in that point, if some.
pub fn get_bus_stop_for_point(lat: f64, lng: f64) -> Option<BusStopInfo> {
    BUS_STOPS.features.iter().find_map(|f| {
        let poly = feature_to_polygon(f);

        let name = f.properties.as_ref().unwrap().get("name").unwrap().as_str().unwrap().to_string();
        let number = f.properties.as_ref().unwrap().get("num").unwrap().as_i64().unwrap() as i32;

        if poly.contains(&geo::Point::new(lng, lat)) {
            let distance = poly.centroid().unwrap().geodesic_distance(&geo::Point::new(lng, lat));

            Some(BusStopInfo { name, number, has_reached: true, timestamp: SystemTime::now(), distance })

        } else {
            None
        }
    })
}

pub struct LatLng {
    pub lat: f64,
    pub lng: f64,
}

pub fn get_next_bus_stop(current: &BusStopInfo, current_post: LatLng) -> BusStopInfo {
    let next = match current.number {
        1..=8 => current.number + 1,
        9 => 1,
        _ => unreachable!(),
    };

    let next_stop = BUS_STOPS.features.iter().find(|f| {
        f.properties.as_ref().unwrap().get("num").unwrap().as_i64().unwrap() as i32 == next
    }).unwrap();
    let name = next_stop.properties.as_ref().unwrap().get("name").unwrap().as_str().unwrap().to_string();
    let number = next_stop.properties.as_ref().unwrap().get("num").unwrap().as_i64().unwrap() as i32;

    let poly = feature_to_polygon(next_stop);
    let distance = poly.centroid().unwrap().geodesic_distance(&geo::Point::new(current_post.lng, current_post.lat));
    BusStopInfo { name, number, has_reached: false, timestamp: SystemTime::now(), distance }
}

pub fn get_distance_to_bus_stop(current: &BusStopInfo, current_post: LatLng) -> f64 {
    let poly = feature_to_polygon(BUS_STOPS.features.iter().find(|f| {
        f.properties.as_ref().unwrap().get("num").unwrap().as_i64().unwrap() as i32 == current.number
    }).unwrap());

    let centroid = poly.centroid().unwrap();
    centroid.geodesic_distance(&geo::Point::new(current_post.lng, current_post.lat))
}

