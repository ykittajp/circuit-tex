// Drawing circuit in Asymptote
pen myfont = fontsize(8pt);


void fillRectangle(real x, real y, real w, real h, pen fp) {
  fill((x, y)--(x+w, y)--(x+w, y+h)--(x, y+h)--cycle, fp);
}
void fillCircle(pair p, real r, pen fp) {
  real x = p.x, y = p.y;
  fill((x+r, y)..(x, y+r)..(x-r, y)..(x, y-r)..cycle, fp);
}
pair slide(pair p, real x, real y) {
  return (p.x+x, p.y+y);
}
pair slideX(pair p, real slide) { return slide(p,slide,0);}
pair slideY(pair p, real slide) { return slide(p,0,slide);}

// 
// Draw Circuit Element
//
real edge = 2;
real pointr = 1.5;

void drawPoint(pair p, pen mypen=currentpen) {
  fill(slideX(p, pointr)..slideY(p, pointr)
       ..slideX(p, -pointr)..slideY(p, -pointr)
       ..cycle, mypen);
}

void drawGND(pair p, pen mypen=currentpen) {
  real w = 6;
  real dh = 4, dw = 1;
  draw(p--slideY(p, -edge), mypen);
  draw(slide(p, -w, -edge)--slide(p, w, -edge), mypen);
  draw(slide(p, -2*w/3, -edge)--slide(p, -2*w/3-dw, -edge-dh), mypen);
  draw(slide(p, 0, -edge)--slide(p, -dw, -edge-dh), mypen);
  draw(slide(p, 2*w/3, -edge)--slide(p, 2*w/3-dw, -edge-dh), mypen);
}

// Drawing voltage
// Parameters:
//   p    start point (top or right)
//   r    is rotate (true is vertical, false is horizontal)
// Return value:
//   Another point (bottom or left)
//
// Width  := edge*2 + (space*2+sh)*n - space = 2 + 6n
// Height := lw                              = 12
// p = top | right
// n = [Picture of Voltage] * n ;
//   Internal use:
//     First, input is bigger than 0
//     Secondly, input is smaller than 0
//   Example:
//     drawVoltage(3) => drawVoltage(-2) => drawVoltage(-1)
pair drawVoltage(pair p, bool r=false, pen mypen=currentpen, string label="", int n=1) {
  real lw = 6;
  real sw = 7, sh = 2;
  real space = 2;
  pair q = p;
  
  if ( r ) {
    if ( n > 0 ) {
      q = slideY(q, -edge);
      draw(p--q, mypen);
      if ( label != "" ) {
	// write label
	// This code block is called when function is called first, only.
	real h = (space*2+sh)*n - space;
	pair lp = slide(q, lw, -h/2);
	label(label, lp, E, myfont);
      }
    }
    draw(slideX(q, -lw)--slideX(q, lw), mypen);
    q = slideY(q, -space-sh);
    fillRectangle(q.x-sw/2, q.y, sw, sh, mypen);
    if ( n == -1 ) {
      draw(q--slideY(q, -edge), mypen);
      q = slideY(q, -edge);
    } else {
      q = slideY(q, -space);
    }
  }else{
    if ( n > 0 ) {
      q = slideX(q, -edge);
      draw(p--q, mypen);
      if ( label != "" ) {
	// write label
	// This code block is caled when function is called first, only.
	real h = (space*sh)*n - space;
	pair lp = slide(q, -h/2, -lw);
	label(label, lp, S, myfont);
      }
    }
    draw(slideY(q, -lw)--slideY(q, lw), mypen);
    q = slideX(q, -space-sh);
    fillRectangle(q.x, q.y-sw/2, sh, sw, mypen);
    if ( n == -1 ) {
      draw(q--slideX(q, -edge), mypen);
      q = slideX(q, -edge);
    } else {
      q = slideX(q, -space);
    }
  }

  if ( n > 0 ) {
    q = drawVoltage(q, r, mypen, "", -n+1);
  } else if ( n < -1 ) {
    q = drawVoltage(q, r, mypen, "", n+1);
  }

  return q;
}

// Width  := sx*14  = 28
// Height := sy*2   = 8
pair drawResistor(pair p,bool r=false, pen mypen=currentpen, string label="") {
  real sx=2, sy=4;
  pair q;
  if ( r ) {
    q = slideY(p, sx*14);
    draw(p--slideY(p, sx)
	 --slide(p, -sy, sx*2)--slide(p, sy, sx*4)
	 --slide(p, -sy, sx*6)--slide(p, sy, sx*8)
	 --slide(p, -sy, sx*10)--slide(p, sy, sx*12)
	 --slideY(p, sx*13)--q, mypen);
    label(label,slideX((p+q)/2, sy), E, myfont);
  } else {
    q = slideX(p, sx*14);
    draw(p--slideX(p, sx)
	 --slide(p, sx*2, -sy)--slide(p, sx*4, sy)
	 --slide(p, sx*6, -sy)--slide(p, sx*8, sy)
	 --slide(p, sx*10, -sy)--slide(p, sx*12, sy)
	 --slideX(p, sx*13)--q, mypen);
    label(label,slideY((p+q)/2,-sy), S, myfont);
  }
  return q;
}


// ////////////////////////////////////////////////////////////

pair p = (0, 30);

// Draw left-side voltage
draw(p--p+(0,-5));
draw(drawVoltage(p+(0,-5), true, currentpen, "$V$", 3)--p+(0,-30));

// Draw up-side resistor
draw(p--p+(16,0));
draw(drawResistor(p+(16,0), false, currentpen, "$R$")--p+(60,0));

// Draw right-side resistor
draw(p+(0,-30)--p+(60,-30)--p+(60,-29));
draw(drawResistor(p+(60,-29), true, currentpen, "$R_L$")--p+(60,0));

// Draw point and ground
drawPoint(p+(0,-30));
draw(p+(0,-30)--p+(0,-40));
drawGND(p+(0,-40));
