require 'test/unit'
require 'cpcluster'

class TestCase < Test::Unit::TestCase
  def test_create_cluster
    clusterer = Clusterer.new
    assert_not_nil clusterer
  end

  def test_simple_calc
    points = [
    {:x=>1, :y=>2, :id=>1},
    {:x=>1, :y=>2, :id=>2},
    {:x=>1.1, :y=>2.1, :id=>3},
    {:x=>3, :y=>0, :id=>4},
    {:x=>4, :y=>6, :id=>5},
    {:x=>5, :y=>7, :id=>6},
    {:x=>5, :y=>7, :id=>7},
    {:x=>5.1, :y=>6.9, :id=>8},
             ].map{|x| x.merge(:idx => x[:id]) } 
    exp_data = [{:x => 1 + 1.0/30, :y => 2.0 + 1.0/30, :ids =>[1,2,3]},
                {:x => 3.0, :y => 0.0, :ids =>[4]},
                {:x => 4.0, :y => 6.0, :ids =>[5]},
                {:x => 5.0 + 1.0/30, :y => 7.0 - 1.0/30, :ids =>[6, 7, 8]}]
    
    clusterer = Clusterer.new
    target = (0.1 ** 2 * 2) ** 0.5 + 0.001
    maxNumPoints = 200
    reduced_cpoints = clusterer.cluster(points, target, maxNumPoints)
    assert_equal exp_data.size, reduced_cpoints.size
    exp_data.each_with_index do |obj, idx|
      actual = reduced_cpoints[idx]
      assert_equal(obj[:ids].size, actual[:numCrashes])
      assert_equal(obj[:ids], actual[:ids])
      assert(close_enough(obj[:x], actual[:x]), "Too far apart: expected #{obj[:x]}, got #{actual[:x]}")
      assert(close_enough(obj[:y], actual[:y]), "Too far apart: expected #{obj[:y]}, got #{actual[:y]}")
    end
  end

  def test_larger_set
    reduced_points = 
[{:y=>49.2347, :x=>-123.173, :id=>0, :idx=>0},
 {:y=>49.2347, :x=>-123.173, :id=>1, :idx=>1},
 {:y=>49.2347, :x=>-123.17, :id=>2, :idx=>2},
 {:y=>49.2347, :x=>-123.17, :id=>3, :idx=>3},
 {:y=>49.2423, :x=>-123.17, :id=>4, :idx=>4},
 {:y=>49.2481, :x=>-123.168, :id=>5, :idx=>5},
 {:y=>49.2481, :x=>-123.168, :id=>6, :idx=>6},
 {:y=>49.2501, :x=>-123.168, :id=>7, :idx=>7},
 {:y=>49.2385, :x=>-123.166, :id=>8, :idx=>8},
 {:y=>49.2347, :x=>-123.164, :id=>9, :idx=>9},
 {:y=>49.2328, :x=>-123.163, :id=>10, :idx=>10},
 {:y=>49.2384, :x=>-123.163, :id=>11, :idx=>11},
 {:y=>49.2384, :x=>-123.163, :id=>12, :idx=>12},
 {:y=>49.2383, :x=>-123.158, :id=>13, :idx=>13},
 {:y=>49.2383, :x=>-123.155, :id=>14, :idx=>14},
 {:y=>49.2383, :x=>-123.155, :id=>15, :idx=>15},
 {:y=>49.2346, :x=>-123.155, :id=>16, :idx=>16},
 {:y=>49.2346, :x=>-123.155, :id=>17, :idx=>17},
 {:y=>49.2346, :x=>-123.155, :id=>18, :idx=>18},
 {:y=>49.2383, :x=>-123.155, :id=>19, :idx=>19},
 {:y=>49.2383, :x=>-123.155, :id=>20, :idx=>20},
 {:y=>49.2346, :x=>-123.154, :id=>21, :idx=>21},
 {:y=>49.243, :x=>-123.153, :id=>22, :idx=>22},
 {:y=>49.2452, :x=>-123.153, :id=>23, :idx=>23},
 {:y=>49.2452, :x=>-123.153, :id=>24, :idx=>24},
 {:y=>49.2345, :x=>-123.152, :id=>25, :idx=>25},
 {:y=>49.2382, :x=>-123.15, :id=>26, :idx=>26},
 {:y=>49.2308, :x=>-123.149, :id=>27, :idx=>27},
 {:y=>49.2326, :x=>-123.148, :id=>28, :idx=>28},
 {:y=>49.2345, :x=>-123.148, :id=>29, :idx=>29},
 {:y=>49.2345, :x=>-123.148, :id=>30, :idx=>30},
 {:y=>49.2357, :x=>-123.148, :id=>31, :idx=>31},
 {:y=>49.242, :x=>-123.146, :id=>32, :idx=>32},
 {:y=>49.242, :x=>-123.146, :id=>33, :idx=>33},
 {:y=>49.2455, :x=>-123.145, :id=>34, :idx=>34},
 {:y=>49.2466, :x=>-123.144, :id=>35, :idx=>35},
 {:y=>49.2381, :x=>-123.144, :id=>36, :idx=>36},
 {:y=>49.2381, :x=>-123.144, :id=>37, :idx=>37},
 {:y=>49.2381, :x=>-123.144, :id=>38, :idx=>38},
 {:y=>49.2381, :x=>-123.144, :id=>39, :idx=>39},
 {:y=>49.2381, :x=>-123.142, :id=>40, :idx=>40},
 {:y=>49.2474, :x=>-123.142, :id=>41, :idx=>41},
 {:y=>49.2344, :x=>-123.141, :id=>42, :idx=>42},
 {:y=>49.2344, :x=>-123.141, :id=>43, :idx=>43},
 {:y=>49.2343, :x=>-123.14, :id=>44, :idx=>44},
 {:y=>49.24, :x=>-123.139, :id=>45, :idx=>45},
 {:y=>49.2437, :x=>-123.139, :id=>46, :idx=>46},
 {:y=>49.2493, :x=>-123.138, :id=>47, :idx=>47},
 {:y=>49.2474, :x=>-123.137, :id=>48, :idx=>48},
 {:y=>49.2464, :x=>-123.13, :id=>49, :idx=>49},
 {:y=>49.2493, :x=>-123.13, :id=>50, :idx=>50},
 {:y=>49.2293, :x=>-123.128, :id=>51, :idx=>51},
 {:y=>49.2339, :x=>-123.128, :id=>52, :idx=>52},
 {:y=>49.2339, :x=>-123.128, :id=>53, :idx=>53},
 {:y=>49.2414, :x=>-123.128, :id=>54, :idx=>54},
 {:y=>49.2414, :x=>-123.128, :id=>55, :idx=>55},
 {:y=>49.2445, :x=>-123.128, :id=>56, :idx=>56},
 {:y=>49.2463, :x=>-123.128, :id=>57, :idx=>57},
 {:y=>49.2463, :x=>-123.128, :id=>58, :idx=>58},
 {:y=>49.2492, :x=>-123.128, :id=>59, :idx=>59},
 {:y=>49.2492, :x=>-123.128, :id=>60, :idx=>60},
 {:y=>49.2513, :x=>-123.127, :id=>61, :idx=>61},
 {:y=>49.2492, :x=>-123.125, :id=>62, :idx=>62},
 {:y=>49.2338, :x=>-123.124, :id=>63, :idx=>63},
 {:y=>49.2338, :x=>-123.124, :id=>64, :idx=>64},
 {:y=>49.2375, :x=>-123.124, :id=>65, :idx=>65},
 {:y=>49.2375, :x=>-123.124, :id=>66, :idx=>66},
 {:y=>49.231, :x=>-123.124, :id=>67, :idx=>67},
 {:y=>49.2462, :x=>-123.12, :id=>68, :idx=>68},
 {:y=>49.2476, :x=>-123.12, :id=>69, :idx=>69},
 {:y=>49.248, :x=>-123.12, :id=>70, :idx=>70},
 {:y=>49.2298, :x=>-123.116, :id=>71, :idx=>71},
 {:y=>49.2335, :x=>-123.116, :id=>72, :idx=>72},
 {:y=>49.2335, :x=>-123.116, :id=>73, :idx=>73},
 {:y=>49.2325, :x=>-123.116, :id=>74, :idx=>74},
 {:y=>49.2325, :x=>-123.116, :id=>75, :idx=>75},
 {:y=>49.2373, :x=>-123.116, :id=>76, :idx=>76},
 {:y=>49.2373, :x=>-123.116, :id=>77, :idx=>77},
 {:y=>49.2452, :x=>-123.116, :id=>78, :idx=>78}]

    cl = Clusterer.new
    target = 0.004 / 10_000
    maxNumPoints = 20
    res = cl.cluster(reduced_points, target, maxNumPoints)
    assert_equal(maxNumPoints - 1, res.size)
  end

  def test_much_bigger_set
    target = 0.00038539728993602283
    maxNumPoints = 200
    points = [{:x=>-123.139, :y=>49.258, :numCrashes=>20, :id=>11976},
 {:x=>-123.139, :y=>49.258, :numCrashes=>6, :id=>98863},
 {:x=>-123.139, :y=>49.258, :numCrashes=>11, :id=>98862},
 {:x=>-123.139, :y=>49.258, :numCrashes=>6, :id=>78193},
 {:x=>-123.139, :y=>49.258, :numCrashes=>16, :id=>78192},
 {:x=>-123.139, :y=>49.258, :numCrashes=>14, :id=>56260},
 {:x=>-123.139, :y=>49.258, :numCrashes=>6, :id=>56259},
 {:x=>-123.139, :y=>49.258, :numCrashes=>16, :id=>34154},
 {:x=>-123.139, :y=>49.258, :numCrashes=>9, :id=>34153},
 {:x=>-123.139, :y=>49.258, :numCrashes=>8, :id=>11977},
 {:x=>-123.139, :y=>49.2589, :numCrashes=>17, :id=>56257},
 {:x=>-123.139, :y=>49.2589, :numCrashes=>3, :id=>56258},
 {:x=>-123.139, :y=>49.2589, :numCrashes=>6, :id=>78190},
 {:x=>-123.139, :y=>49.2589, :numCrashes=>13, :id=>78191},
 {:x=>-123.139, :y=>49.2589, :numCrashes=>16, :id=>98860},
 {:x=>-123.139, :y=>49.2589, :numCrashes=>6, :id=>98861},
 {:x=>-123.139, :y=>49.2589, :numCrashes=>4, :id=>34152},
 {:x=>-123.139, :y=>49.2589, :numCrashes=>15, :id=>34151},
 {:x=>-123.139, :y=>49.2589, :numCrashes=>11, :id=>11974},
 {:x=>-123.139, :y=>49.2589, :numCrashes=>2, :id=>11975},
 {:x=>-123.139, :y=>49.2598, :numCrashes=>6, :id=>11972},
 {:x=>-123.139, :y=>49.2598, :numCrashes=>4, :id=>11973},
 {:x=>-123.139, :y=>49.2598, :numCrashes=>9, :id=>98859},
 {:x=>-123.139, :y=>49.2598, :numCrashes=>4, :id=>98858},
 {:x=>-123.139, :y=>49.2598, :numCrashes=>5, :id=>78189},
 {:x=>-123.139, :y=>49.2598, :numCrashes=>12, :id=>56255},
 {:x=>-123.139, :y=>49.2598, :numCrashes=>2, :id=>56256},
 {:x=>-123.139, :y=>49.2598, :numCrashes=>4, :id=>34150},
 {:x=>-123.139, :y=>49.2598, :numCrashes=>17, :id=>34149},
 {:x=>-123.139, :y=>49.2598, :numCrashes=>7, :id=>78188},
 {:x=>-123.139, :y=>49.2608, :numCrashes=>19, :id=>98857},
 {:x=>-123.139, :y=>49.2608, :numCrashes=>32, :id=>98856},
 {:x=>-123.139, :y=>49.2608, :numCrashes=>13, :id=>78187},
 {:x=>-123.139, :y=>49.2608, :numCrashes=>37, :id=>78186},
 {:x=>-123.139, :y=>49.2608, :numCrashes=>40, :id=>56254},
 {:x=>-123.139, :y=>49.2608, :numCrashes=>14, :id=>56253},
 {:x=>-123.139, :y=>49.2608, :numCrashes=>14, :id=>34148},
 {:x=>-123.139, :y=>49.2608, :numCrashes=>50, :id=>34147},
 {:x=>-123.139, :y=>49.2608, :numCrashes=>47, :id=>11971},
 {:x=>-123.139, :y=>49.2608, :numCrashes=>17, :id=>11970},
 {:x=>-123.139, :y=>49.2617, :numCrashes=>3, :id=>78184},
 {:x=>-123.139, :y=>49.2617, :numCrashes=>11, :id=>78185},
 {:x=>-123.139, :y=>49.2617, :numCrashes=>11, :id=>98854},
 {:x=>-123.139, :y=>49.2617, :numCrashes=>2, :id=>98855},
 {:x=>-123.139, :y=>49.2617, :numCrashes=>15, :id=>56252},
 {:x=>-123.139, :y=>49.2617, :numCrashes=>4, :id=>56251},
 {:x=>-123.139, :y=>49.2617, :numCrashes=>4, :id=>34146},
 {:x=>-123.139, :y=>49.2617, :numCrashes=>10, :id=>34145},
 {:x=>-123.139, :y=>49.2617, :numCrashes=>5, :id=>11969},
 {:x=>-123.139, :y=>49.2617, :numCrashes=>11, :id=>11968},
 {:x=>-123.139, :y=>49.2636, :numCrashes=>26, :id=>78265},
 {:x=>-123.139, :y=>49.2636, :numCrashes=>53, :id=>78266},
 {:x=>-123.139, :y=>49.2636, :numCrashes=>40, :id=>98933},
 {:x=>-123.139, :y=>49.2636, :numCrashes=>18, :id=>98934},
 {:x=>-123.139, :y=>49.2636, :numCrashes=>74, :id=>56335},
 {:x=>-123.139, :y=>49.2636, :numCrashes=>18, :id=>56334},
 {:x=>-123.139, :y=>49.2636, :numCrashes=>67, :id=>34230},
 {:x=>-123.139, :y=>49.2636, :numCrashes=>18, :id=>34229},
 {:x=>-123.139, :y=>49.2636, :numCrashes=>56, :id=>12050},
 {:x=>-123.139, :y=>49.2636, :numCrashes=>29, :id=>12049},
 {:x=>-123.139, :y=>49.2626, :numCrashes=>1, :id=>78182},
 {:x=>-123.139, :y=>49.2626, :numCrashes=>14, :id=>78183},
 {:x=>-123.139, :y=>49.2626, :numCrashes=>4, :id=>98852},
 {:x=>-123.139, :y=>49.2626, :numCrashes=>12, :id=>98853},
 {:x=>-123.139, :y=>49.2626, :numCrashes=>6, :id=>56250},
 {:x=>-123.139, :y=>49.2626, :numCrashes=>29, :id=>56249},
 {:x=>-123.139, :y=>49.2626, :numCrashes=>18, :id=>34144},
 {:x=>-123.139, :y=>49.2626, :numCrashes=>6, :id=>34143},
 {:x=>-123.139, :y=>49.2626, :numCrashes=>16, :id=>11967},
 {:x=>-123.139, :y=>49.2626, :numCrashes=>5, :id=>11966},
 {:x=>-123.139, :y=>49.2645, :numCrashes=>4, :id=>78263},
 {:x=>-123.139, :y=>49.2645, :numCrashes=>13, :id=>78264},
 {:x=>-123.139, :y=>49.2645, :numCrashes=>3, :id=>98931},
 {:x=>-123.139, :y=>49.2645, :numCrashes=>2, :id=>98932},
 {:x=>-123.139, :y=>49.2645, :numCrashes=>16, :id=>56333},
 {:x=>-123.139, :y=>49.2645, :numCrashes=>15, :id=>56332},
 {:x=>-123.139, :y=>49.2645, :numCrashes=>6, :id=>34228},
 {:x=>-123.139, :y=>49.2645, :numCrashes=>6, :id=>34227},
 {:x=>-123.139, :y=>49.2645, :numCrashes=>10, :id=>12048},
 {:x=>-123.139, :y=>49.2645, :numCrashes=>4, :id=>12047},
 {:x=>-123.136, :y=>49.2589, :numCrashes=>4, :id=>78379},
 {:x=>-123.136, :y=>49.2589, :numCrashes=>6, :id=>78380},
 {:x=>-123.136, :y=>49.2589, :numCrashes=>3, :id=>99048},
 {:x=>-123.136, :y=>49.2589, :numCrashes=>1, :id=>99049},
 {:x=>-123.136, :y=>49.2589, :numCrashes=>3, :id=>56450},
 {:x=>-123.136, :y=>49.2589, :numCrashes=>4, :id=>56449},
 {:x=>-123.136, :y=>49.2589, :numCrashes=>6, :id=>34354},
 {:x=>-123.136, :y=>49.2589, :numCrashes=>4, :id=>34353},
 {:x=>-123.136, :y=>49.2589, :numCrashes=>4, :id=>12171},
 {:x=>-123.136, :y=>49.2589, :numCrashes=>9, :id=>12170},
 {:x=>-123.136, :y=>49.2598, :numCrashes=>1, :id=>99047},
 {:x=>-123.136, :y=>49.2598, :numCrashes=>1, :id=>99046},
 {:x=>-123.136, :y=>49.2598, :numCrashes=>3, :id=>78378},
 {:x=>-123.136, :y=>49.2598, :numCrashes=>3, :id=>78377},
 {:x=>-123.136, :y=>49.2598, :numCrashes=>5, :id=>56448},
 {:x=>-123.136, :y=>49.2598, :numCrashes=>6, :id=>56447},
 {:x=>-123.136, :y=>49.2598, :numCrashes=>10, :id=>34352},
 {:x=>-123.136, :y=>49.2598, :numCrashes=>3, :id=>34351},
 {:x=>-123.136, :y=>49.2598, :numCrashes=>9, :id=>12169},
 {:x=>-123.136, :y=>49.2608, :numCrashes=>20, :id=>99045},
 {:x=>-123.136, :y=>49.2608, :numCrashes=>8, :id=>99044},
 {:x=>-123.136, :y=>49.2608, :numCrashes=>8, :id=>78376},
 {:x=>-123.136, :y=>49.2608, :numCrashes=>20, :id=>78375},
 {:x=>-123.136, :y=>49.2608, :numCrashes=>5, :id=>56446},
 {:x=>-123.136, :y=>49.2608, :numCrashes=>14, :id=>56445},
 {:x=>-123.136, :y=>49.2608, :numCrashes=>13, :id=>34350},
 {:x=>-123.136, :y=>49.2608, :numCrashes=>15, :id=>34349},
 {:x=>-123.136, :y=>49.2608, :numCrashes=>13, :id=>12168},
 {:x=>-123.136, :y=>49.2608, :numCrashes=>13, :id=>12167},
 {:x=>-123.136, :y=>49.2617, :numCrashes=>6, :id=>99043},
 {:x=>-123.136, :y=>49.2617, :numCrashes=>3, :id=>99042},
 {:x=>-123.136, :y=>49.2617, :numCrashes=>4, :id=>78374},
 {:x=>-123.136, :y=>49.2617, :numCrashes=>2, :id=>56444},
 {:x=>-123.136, :y=>49.2617, :numCrashes=>4, :id=>56443},
 {:x=>-123.136, :y=>49.2617, :numCrashes=>5, :id=>34348},
 {:x=>-123.136, :y=>49.2617, :numCrashes=>4, :id=>34347},
 {:x=>-123.136, :y=>49.2617, :numCrashes=>3, :id=>12166},
 {:x=>-123.136, :y=>49.2617, :numCrashes=>4, :id=>12165},
 {:x=>-123.136, :y=>49.2626, :numCrashes=>6, :id=>99041},
 {:x=>-123.136, :y=>49.2626, :numCrashes=>5, :id=>99040},
 {:x=>-123.136, :y=>49.2626, :numCrashes=>5, :id=>78373},
 {:x=>-123.136, :y=>49.2626, :numCrashes=>11, :id=>78372},
 {:x=>-123.136, :y=>49.2626, :numCrashes=>5, :id=>56442},
 {:x=>-123.136, :y=>49.2626, :numCrashes=>8, :id=>56441},
 {:x=>-123.136, :y=>49.2626, :numCrashes=>3, :id=>34346},
 {:x=>-123.136, :y=>49.2626, :numCrashes=>9, :id=>34345},
 {:x=>-123.136, :y=>49.2626, :numCrashes=>9, :id=>12164},
 {:x=>-123.136, :y=>49.2626, :numCrashes=>6, :id=>12163},
 {:x=>-123.136, :y=>49.2636, :numCrashes=>8, :id=>78390},
 {:x=>-123.136, :y=>49.2636, :numCrashes=>32, :id=>78391},
 {:x=>-123.136, :y=>49.2636, :numCrashes=>20, :id=>99059},
 {:x=>-123.136, :y=>49.2636, :numCrashes=>12, :id=>99060},
 {:x=>-123.136, :y=>49.2636, :numCrashes=>25, :id=>56462},
 {:x=>-123.136, :y=>49.2636, :numCrashes=>15, :id=>56461},
 {:x=>-123.136, :y=>49.2636, :numCrashes=>38, :id=>34365},
 {:x=>-123.136, :y=>49.2636, :numCrashes=>23, :id=>34364},
 {:x=>-123.136, :y=>49.2636, :numCrashes=>29, :id=>12183},
 {:x=>-123.136, :y=>49.2636, :numCrashes=>18, :id=>12182},
 {:x=>-123.136, :y=>49.2645, :numCrashes=>11, :id=>78388},
 {:x=>-123.136, :y=>49.2645, :numCrashes=>1, :id=>78389},
 {:x=>-123.136, :y=>49.2645, :numCrashes=>9, :id=>99057},
 {:x=>-123.136, :y=>49.2645, :numCrashes=>9, :id=>99058},
 {:x=>-123.136, :y=>49.2645, :numCrashes=>1, :id=>56460},
 {:x=>-123.136, :y=>49.2645, :numCrashes=>9, :id=>56459},
 {:x=>-123.136, :y=>49.2645, :numCrashes=>2, :id=>34363},
 {:x=>-123.136, :y=>49.2645, :numCrashes=>13, :id=>34362},
 {:x=>-123.136, :y=>49.2645, :numCrashes=>8, :id=>12181},
 {:x=>-123.136, :y=>49.2645, :numCrashes=>5, :id=>12180},
 {:x=>-123.134, :y=>49.2588, :numCrashes=>1, :id=>54006},
 {:x=>-123.134, :y=>49.2588, :numCrashes=>1, :id=>31820},
 {:x=>-123.134, :y=>49.2588, :numCrashes=>1, :id=>9678},
 {:x=>-123.134, :y=>49.2597, :numCrashes=>1, :id=>96711},
 {:x=>-123.134, :y=>49.2597, :numCrashes=>1, :id=>75974},
 {:x=>-123.134, :y=>49.2597, :numCrashes=>1, :id=>54005},
 {:x=>-123.134, :y=>49.2597, :numCrashes=>1, :id=>31819},
 {:x=>-123.134, :y=>49.2607, :numCrashes=>1, :id=>96710},
 {:x=>-123.134, :y=>49.2607, :numCrashes=>1, :id=>75973},
 {:x=>-123.134, :y=>49.2607, :numCrashes=>6, :id=>75972},
 {:x=>-123.134, :y=>49.2607, :numCrashes=>3, :id=>54004},
 {:x=>-123.134, :y=>49.2607, :numCrashes=>8, :id=>54003},
 {:x=>-123.134, :y=>49.2607, :numCrashes=>6, :id=>31818},
 {:x=>-123.134, :y=>49.2607, :numCrashes=>4, :id=>31817},
 {:x=>-123.134, :y=>49.2607, :numCrashes=>2, :id=>9677},
 {:x=>-123.134, :y=>49.2607, :numCrashes=>3, :id=>9676},
 {:x=>-123.134, :y=>49.2616, :numCrashes=>1, :id=>54002},
 {:x=>-123.134, :y=>49.2616, :numCrashes=>1, :id=>31816},
 {:x=>-123.134, :y=>49.2616, :numCrashes=>1, :id=>9675},
 {:x=>-123.134, :y=>49.2626, :numCrashes=>3, :id=>96709},
 {:x=>-123.134, :y=>49.2626, :numCrashes=>2, :id=>96708},
 {:x=>-123.134, :y=>49.2626, :numCrashes=>1, :id=>75971},
 {:x=>-123.134, :y=>49.2626, :numCrashes=>1, :id=>75970},
 {:x=>-123.134, :y=>49.2626, :numCrashes=>1, :id=>54001},
 {:x=>-123.134, :y=>49.2626, :numCrashes=>1, :id=>9674},
 {:x=>-123.134, :y=>49.2626, :numCrashes=>1, :id=>9673},
 {:x=>-123.134, :y=>49.2635, :numCrashes=>2, :id=>96718},
 {:x=>-123.134, :y=>49.2635, :numCrashes=>4, :id=>96717},
 {:x=>-123.134, :y=>49.2635, :numCrashes=>1, :id=>75980},
 {:x=>-123.134, :y=>49.2635, :numCrashes=>3, :id=>75979},
 {:x=>-123.134, :y=>49.2635, :numCrashes=>7, :id=>54010},
 {:x=>-123.134, :y=>49.2635, :numCrashes=>11, :id=>54009},
 {:x=>-123.134, :y=>49.2635, :numCrashes=>6, :id=>31825},
 {:x=>-123.134, :y=>49.2635, :numCrashes=>5, :id=>31824},
 {:x=>-123.134, :y=>49.2635, :numCrashes=>6, :id=>9685},
 {:x=>-123.134, :y=>49.2635, :numCrashes=>4, :id=>9684},
 {:x=>-123.134, :y=>49.2644, :numCrashes=>3, :id=>96716},
 {:x=>-123.134, :y=>49.2644, :numCrashes=>1, :id=>54008},
 {:x=>-123.134, :y=>49.2644, :numCrashes=>1, :id=>54007},
 {:x=>-123.134, :y=>49.2644, :numCrashes=>1, :id=>31823},
 {:x=>-123.134, :y=>49.2644, :numCrashes=>1, :id=>9683},
 {:x=>-123.132, :y=>49.2588, :numCrashes=>1, :id=>96399},
 {:x=>-123.132, :y=>49.2588, :numCrashes=>1, :id=>53658},
 {:x=>-123.132, :y=>49.2588, :numCrashes=>1, :id=>31474},
 {:x=>-123.132, :y=>49.2588, :numCrashes=>1, :id=>9347},
 {:x=>-123.132, :y=>49.2597, :numCrashes=>2, :id=>31473},
 {:x=>-123.132, :y=>49.2597, :numCrashes=>1, :id=>53657},
 {:x=>-123.132, :y=>49.2597, :numCrashes=>1, :id=>96398},
 {:x=>-123.131, :y=>49.2607, :numCrashes=>3, :id=>96397},
 {:x=>-123.131, :y=>49.2607, :numCrashes=>2, :id=>96396},
 {:x=>-123.131, :y=>49.2607, :numCrashes=>3, :id=>75668},
 {:x=>-123.131, :y=>49.2607, :numCrashes=>2, :id=>75667},
 {:x=>-123.131, :y=>49.2607, :numCrashes=>9, :id=>53656},
 {:x=>-123.131, :y=>49.2607, :numCrashes=>2, :id=>31472},
 {:x=>-123.131, :y=>49.2607, :numCrashes=>3, :id=>9346},
 {:x=>-123.131, :y=>49.2607, :numCrashes=>7, :id=>9345},
 {:x=>-123.131, :y=>49.2616, :numCrashes=>1, :id=>53655},
 {:x=>-123.131, :y=>49.2616, :numCrashes=>2, :id=>96394},
 {:x=>-123.131, :y=>49.2616, :numCrashes=>2, :id=>96395},
 {:x=>-123.131, :y=>49.2625, :numCrashes=>1, :id=>96393},
 {:x=>-123.131, :y=>49.2625, :numCrashes=>2, :id=>96392},
 {:x=>-123.131, :y=>49.2625, :numCrashes=>2, :id=>31471},
 {:x=>-123.131, :y=>49.2625, :numCrashes=>1, :id=>31470},
 {:x=>-123.131, :y=>49.2635, :numCrashes=>1, :id=>96403},
 {:x=>-123.131, :y=>49.2635, :numCrashes=>8, :id=>96402},
 {:x=>-123.131, :y=>49.2635, :numCrashes=>9, :id=>75672},
 {:x=>-123.131, :y=>49.2635, :numCrashes=>4, :id=>75671},
 {:x=>-123.131, :y=>49.2635, :numCrashes=>4, :id=>53664},
 {:x=>-123.131, :y=>49.2635, :numCrashes=>11, :id=>53663},
 {:x=>-123.131, :y=>49.2635, :numCrashes=>8, :id=>31479},
 {:x=>-123.131, :y=>49.2635, :numCrashes=>9, :id=>31478},
 {:x=>-123.131, :y=>49.2635, :numCrashes=>7, :id=>9350},
 {:x=>-123.131, :y=>49.2635, :numCrashes=>6, :id=>9349},
 {:x=>-123.131, :y=>49.2644, :numCrashes=>2, :id=>53662},
 {:x=>-123.129, :y=>49.2588, :numCrashes=>1, :id=>99783},
 {:x=>-123.129, :y=>49.2588, :numCrashes=>1, :id=>79163},
 {:x=>-123.129, :y=>49.2588, :numCrashes=>1, :id=>35158},
 {:x=>-123.129, :y=>49.2597, :numCrashes=>1, :id=>35157},
 {:x=>-123.129, :y=>49.2597, :numCrashes=>3, :id=>57239},
 {:x=>-123.129, :y=>49.2606, :numCrashes=>2, :id=>99782},
 {:x=>-123.129, :y=>49.2606, :numCrashes=>4, :id=>99781},
 {:x=>-123.129, :y=>49.2606, :numCrashes=>1, :id=>79162},
 {:x=>-123.129, :y=>49.2606, :numCrashes=>2, :id=>79161},
 {:x=>-123.129, :y=>49.2606, :numCrashes=>3, :id=>57238},
 {:x=>-123.129, :y=>49.2606, :numCrashes=>6, :id=>57237},
 {:x=>-123.129, :y=>49.2606, :numCrashes=>2, :id=>35156},
 {:x=>-123.129, :y=>49.2606, :numCrashes=>6, :id=>35155},
 {:x=>-123.129, :y=>49.2606, :numCrashes=>1, :id=>12967},
 {:x=>-123.129, :y=>49.2616, :numCrashes=>1, :id=>35154},
 {:x=>-123.129, :y=>49.2616, :numCrashes=>1, :id=>57236},
 {:x=>-123.129, :y=>49.2625, :numCrashes=>1, :id=>99780},
 {:x=>-123.129, :y=>49.2625, :numCrashes=>3, :id=>79160},
 {:x=>-123.129, :y=>49.2625, :numCrashes=>1, :id=>57235},
 {:x=>-123.129, :y=>49.2625, :numCrashes=>1, :id=>57234},
 {:x=>-123.129, :y=>49.2625, :numCrashes=>1, :id=>35153},
 {:x=>-123.129, :y=>49.2625, :numCrashes=>3, :id=>12966},
 {:x=>-123.129, :y=>49.2625, :numCrashes=>1, :id=>12965},
 {:x=>-123.129, :y=>49.2634, :numCrashes=>1, :id=>99789},
 {:x=>-123.129, :y=>49.2634, :numCrashes=>1, :id=>99788},
 {:x=>-123.129, :y=>49.2634, :numCrashes=>1, :id=>79166},
 {:x=>-123.129, :y=>49.2634, :numCrashes=>2, :id=>79165},
 {:x=>-123.129, :y=>49.2634, :numCrashes=>2, :id=>57243},
 {:x=>-123.129, :y=>49.2634, :numCrashes=>6, :id=>57242},
 {:x=>-123.129, :y=>49.2634, :numCrashes=>3, :id=>35163},
 {:x=>-123.129, :y=>49.2634, :numCrashes=>4, :id=>35162},
 {:x=>-123.129, :y=>49.2634, :numCrashes=>4, :id=>12971},
 {:x=>-123.129, :y=>49.2634, :numCrashes=>2, :id=>12970},
 {:x=>-123.129, :y=>49.2644, :numCrashes=>1, :id=>99787},
 {:x=>-123.129, :y=>49.2644, :numCrashes=>1, :id=>79164},
 {:x=>-123.129, :y=>49.2644, :numCrashes=>2, :id=>57241},
 {:x=>-123.129, :y=>49.2644, :numCrashes=>1, :id=>35161},
 {:x=>-123.129, :y=>49.2644, :numCrashes=>2, :id=>12969},
 {:x=>-123.127, :y=>49.2587, :numCrashes=>4, :id=>99541},
 {:x=>-123.127, :y=>49.2587, :numCrashes=>3, :id=>99540},
 {:x=>-123.127, :y=>49.2587, :numCrashes=>6, :id=>78917},
 {:x=>-123.127, :y=>49.2587, :numCrashes=>4, :id=>78916},
 {:x=>-123.127, :y=>49.2587, :numCrashes=>15, :id=>56984},
 {:x=>-123.127, :y=>49.2587, :numCrashes=>4, :id=>56983},
 {:x=>-123.127, :y=>49.2587, :numCrashes=>6, :id=>34894},
 {:x=>-123.127, :y=>49.2587, :numCrashes=>8, :id=>34893},
 {:x=>-123.127, :y=>49.2587, :numCrashes=>1, :id=>12717},
 {:x=>-123.127, :y=>49.2587, :numCrashes=>6, :id=>12716},
 {:x=>-123.127, :y=>49.2596, :numCrashes=>4, :id=>99539},
 {:x=>-123.127, :y=>49.2596, :numCrashes=>3, :id=>78915},
 {:x=>-123.127, :y=>49.2596, :numCrashes=>4, :id=>78914},
 {:x=>-123.127, :y=>49.2596, :numCrashes=>3, :id=>56982},
 {:x=>-123.127, :y=>49.2596, :numCrashes=>1, :id=>56981},
 {:x=>-123.127, :y=>49.2596, :numCrashes=>2, :id=>34892},
 {:x=>-123.127, :y=>49.2596, :numCrashes=>9, :id=>34891},
 {:x=>-123.127, :y=>49.2596, :numCrashes=>4, :id=>12715},
 {:x=>-123.127, :y=>49.2596, :numCrashes=>6, :id=>12714},
 {:x=>-123.127, :y=>49.2606, :numCrashes=>26, :id=>99538},
 {:x=>-123.127, :y=>49.2606, :numCrashes=>18, :id=>99537},
 {:x=>-123.127, :y=>49.2606, :numCrashes=>15, :id=>78913},
 {:x=>-123.127, :y=>49.2606, :numCrashes=>46, :id=>78912},
 {:x=>-123.127, :y=>49.2606, :numCrashes=>43, :id=>56980},
 {:x=>-123.127, :y=>49.2606, :numCrashes=>16, :id=>56979},
 {:x=>-123.127, :y=>49.2606, :numCrashes=>20, :id=>34890},
 {:x=>-123.127, :y=>49.2606, :numCrashes=>45, :id=>34889},
 {:x=>-123.127, :y=>49.2606, :numCrashes=>43, :id=>12713},
 {:x=>-123.127, :y=>49.2606, :numCrashes=>12, :id=>12712},
 {:x=>-123.127, :y=>49.2615, :numCrashes=>3, :id=>99536},
 {:x=>-123.127, :y=>49.2615, :numCrashes=>1, :id=>78911},
 {:x=>-123.127, :y=>49.2615, :numCrashes=>2, :id=>78910},
 {:x=>-123.127, :y=>49.2615, :numCrashes=>2, :id=>56978},
 {:x=>-123.127, :y=>49.2615, :numCrashes=>4, :id=>56977},
 {:x=>-123.127, :y=>49.2615, :numCrashes=>2, :id=>34888},
 {:x=>-123.127, :y=>49.2615, :numCrashes=>3, :id=>34887},
 {:x=>-123.127, :y=>49.2615, :numCrashes=>2, :id=>12711},
 {:x=>-123.127, :y=>49.2615, :numCrashes=>7, :id=>12710},
 {:x=>-123.127, :y=>49.2624, :numCrashes=>8, :id=>99535},
 {:x=>-123.127, :y=>49.2624, :numCrashes=>2, :id=>78909},
 {:x=>-123.127, :y=>49.2624, :numCrashes=>3, :id=>78908},
 {:x=>-123.127, :y=>49.2624, :numCrashes=>2, :id=>56976},
 {:x=>-123.127, :y=>49.2624, :numCrashes=>10, :id=>56975},
 {:x=>-123.127, :y=>49.2624, :numCrashes=>2, :id=>34886},
 {:x=>-123.127, :y=>49.2624, :numCrashes=>13, :id=>34885},
 {:x=>-123.127, :y=>49.2624, :numCrashes=>5, :id=>12709},
 {:x=>-123.127, :y=>49.2624, :numCrashes=>11, :id=>12708},
 {:x=>-123.127, :y=>49.2634, :numCrashes=>15, :id=>99609},
 {:x=>-123.127, :y=>49.2634, :numCrashes=>28, :id=>99608},
 {:x=>-123.127, :y=>49.2634, :numCrashes=>32, :id=>78989},
 {:x=>-123.127, :y=>49.2634, :numCrashes=>17, :id=>78988},
 {:x=>-123.127, :y=>49.2634, :numCrashes=>20, :id=>57059},
 {:x=>-123.127, :y=>49.2634, :numCrashes=>43, :id=>57058},
 {:x=>-123.127, :y=>49.2634, :numCrashes=>24, :id=>34970},
 {:x=>-123.127, :y=>49.2634, :numCrashes=>35, :id=>34969},
 {:x=>-123.127, :y=>49.2634, :numCrashes=>40, :id=>12791},
 {:x=>-123.127, :y=>49.2634, :numCrashes=>22, :id=>12790},
 {:x=>-123.127, :y=>49.2643, :numCrashes=>5, :id=>99606},
 {:x=>-123.127, :y=>49.2643, :numCrashes=>1, :id=>78987},
 {:x=>-123.127, :y=>49.2643, :numCrashes=>4, :id=>78986},
 {:x=>-123.127, :y=>49.2643, :numCrashes=>8, :id=>57057},
 {:x=>-123.127, :y=>49.2643, :numCrashes=>1, :id=>57056},
 {:x=>-123.127, :y=>49.2643, :numCrashes=>7, :id=>34968},
 {:x=>-123.127, :y=>49.2643, :numCrashes=>1, :id=>34967},
 {:x=>-123.127, :y=>49.2643, :numCrashes=>6, :id=>12789},
              {:x=>-123.127, :y=>49.2643, :numCrashes=>2, :id=>12788},
              {:x=>-123.127, :y=>49.2643, :numCrashes=>2, :id=>99607}]
    points.each_with_index{|obj, idx| obj[:id] = obj[:idx] = idx }
    

    cl = Clusterer.new
    res = cl.cluster(points, target, maxNumPoints)
    assert(res.size < maxNumPoints, "expected at most #{maxNumPoints} points, got #{res.size}")
  end

  def close_enough(x, y)
    return (x - y).abs < 0.0001
  end
end
    
