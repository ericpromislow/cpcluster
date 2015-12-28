# cpcluster
** closest-pair C library and Ruby bindings**

## Usage

    require 'cpcluster'

    points = [
        {:x=>1, :y=>2, :id=>1},
        {:x=>1, :y=>2, :id=>2},
        {:x=>1.1, :y=>2.1, :id=>3},
        {:x=>3, :y=>0, :id=>4},
        {:x=>4, :y=>6, :id=>5},
        {:x=>5, :y=>7, :id=>6},
        {:x=>5, :y=>7, :id=>7},
        {:x=>5.1, :y=>6.9, :id=>8},
          ]    
    clusterer = Clusterer.new
    # Min distance between any two clusters: sqrt(0.02) + .001
    target = (0.1 ** 2 * 2) ** 0.5 + 0.001 
    maxNumPoints = 200
    reduced_cpoints = clusterer.cluster(points, target, maxNumPoints)
    require 'pp'
    pp reduced_cpoints
      
