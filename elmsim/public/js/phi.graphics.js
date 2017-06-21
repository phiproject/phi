var xScale = d3.scaleLinear()
    .domain([30.5234 - 0.01, 30.5234 + 0.01])
    .range([100, window.innerWidth - 100]);

var yScale = d3.scaleLinear()
    .domain([50.4501 - 0.01, 50.4501 + 0.01])
    .range([100, window.innerHeight - 100]);

function setX(node) {
    return xScale(node.label.pos.x);
}

function setY(node) {
    return yScale(node.label.pos.y);
}

function isGenerator(d) {
    return d.label.nodeType == "generator" && ["solarPanel", "windTurbine"].indexOf(d.label.generatorType > -1);
}

function generatorInitialShadow()
{
    return d3.symbol()
        .size(0)
        .type(nodeShape);
}

function transactionShadow() {
    return d3.symbol()
        .size(function (d) {
            if (isGenerator(d)) {
                return 70 + 500 * (d.label.dailyGeneration[0] || 0);
            } else {
                return 0;
            }
        })
        .type(nodeShape);
}

function nodeShape(d) {
    var defaultSymbol = d3.symbolCircle;
    switch (d.label.nodeType) {
        case "peer":
            return d3.symbolCircle;

        case "generator" :
            switch (d.label.generatorType) {
                case "solarPanel":
                    return d3.symbolSquare;
                case "windTurbine":
                    return d3.symbolTriangle;
                default:
                    return defaultSymbol;
            }

        default:
            return defaultSymbol;
    }
}

function peerSize(d) {
    if (d.label.nodeType == "peer") {
        return 20 + 2 * (d.label.desiredConsumption || 0);
    }
}

function peerSizeOuter(d) {
    if (d.label.nodeType == "peer") {
        return 20 + 2 * (d.label.desiredConsumption || 0);
    }
}

function peerFullOutline() {
    return d3.arc()
        .innerRadius(peerSize)
        .outerRadius(peerSize)
        .startAngle(0)
        .endAngle(2 * Math.PI);
}

function peerOutline() {
    return d3.arc()
        .innerRadius(peerSize)
        .outerRadius(peerSizeOuter)
        .startAngle(0)
        .endAngle(function(d){
            return d.label.actualConsumption && d.label.actualConsumption.length
                ? Math.min(2 * Math.PI, 2 * Math.PI * d.label.actualConsumption[0]/ d.label.desiredConsumption)
                : 0
        } );
}

function addBaseNode() {
    return d3.symbol()
        .size(70)
        .type(nodeShape);
}