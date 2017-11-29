// delineateSections: function to automatically create episodic divisions
// currently only even divisions
{|parent, size, overlap = 0.25|
  var divisions, div;
  div = 1/size; // reciprocal

  // return
  size.collect{|val|
    val = val+1;
    [(div*(val-1))-(div*overlap*0.5), (div*val)+(div*overlap*0.5)].clip(0,1);
  };
}
