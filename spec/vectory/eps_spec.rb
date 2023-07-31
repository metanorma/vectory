require "spec_helper"

RSpec.describe Vectory::Eps do
  describe "#to_svg" do
    it "returns svg content", skip: 'Temporarily skipped with xit' do
      input = <<~INPUT
        %!PS-Adobe-3.0 EPSF-3.0
        %%Document-Fonts: Times-Roman
        %%Title: circle.eps
        %%Creator: PS_Write.F
        %%CreationDate: 02-Aug-99
        %%Pages: 1
        %%BoundingBox:   36   36  576  756
        %%LanguageLevel: 1
        %%EndComments
        %%BeginProlog
        %%EndProlog
        /inch {72 mul} def
        /Palatino-Roman findfont
        1.00 inch scalefont
        setfont
         0.0000 0.0000 0.0000 setrgbcolor
        %% Page:     1    1
        save
          63 153 moveto
         newpath
          63 153 moveto
         549 153 lineto
         stroke
         newpath
         549 153 moveto
         549 639 lineto
         stroke
         newpath
         549 639 moveto
          63 639 lineto
         stroke
         newpath
          63 639 moveto
          63 153 lineto
         stroke
         newpath
         360 261 108   0 360 arc
         closepath stroke
         newpath
         361 357 moveto
         358 358 lineto
         353 356 lineto
         348 353 lineto
         342 347 lineto
         336 340 lineto
         329 331 lineto
         322 321 lineto
         315 309 lineto
         307 296 lineto
         300 283 lineto
         292 268 lineto
         285 253 lineto
         278 237 lineto
         271 222 lineto
         266 206 lineto
         260 191 lineto
         256 177 lineto
         252 164 lineto
         249 152 lineto
         247 141 lineto
         246 131 lineto
         246 123 lineto
         247 117 lineto
         248 113 lineto
         251 111 lineto
         254 110 lineto
         259 112 lineto
         264 115 lineto
         270 121 lineto
         276 128 lineto
         283 137 lineto
         290 147 lineto
         297 159 lineto
         305 172 lineto
         312 185 lineto
         320 200 lineto
         327 215 lineto
         334 231 lineto
         341 246 lineto
         346 262 lineto
         352 277 lineto
         356 291 lineto
         360 304 lineto
         363 316 lineto
         365 327 lineto
         366 337 lineto
         366 345 lineto
         365 351 lineto
         364 355 lineto
         361 357 lineto
         stroke
         newpath
         171 261 moveto
         171 531 lineto
         stroke
         newpath
         198 261 moveto
         198 531 lineto
         stroke
         newpath
         225 261 moveto
         225 531 lineto
         stroke
         newpath
         252 261 moveto
         252 531 lineto
         stroke
         newpath
         279 261 moveto
         279 531 lineto
         stroke
         newpath
         306 261 moveto
         306 531 lineto
         stroke
         newpath
         333 261 moveto
         333 531 lineto
         stroke
         newpath
         360 261 moveto
         360 531 lineto
         stroke
         newpath
         387 261 moveto
         387 531 lineto
         stroke
         newpath
         414 261 moveto
         414 531 lineto
         stroke
         newpath
         441 261 moveto
         441 531 lineto
         stroke
         newpath
         171 261 moveto
         441 261 lineto
         stroke
         newpath
         171 288 moveto
         441 288 lineto
         stroke
         newpath
         171 315 moveto
         441 315 lineto
         stroke
         newpath
         171 342 moveto
         441 342 lineto
         stroke
         newpath
         171 369 moveto
         441 369 lineto
         stroke
         newpath
         171 396 moveto
         441 396 lineto
         stroke
         newpath
         171 423 moveto
         441 423 lineto
         stroke
         newpath
         171 450 moveto
         441 450 lineto
         stroke
         newpath
         171 477 moveto
         441 477 lineto
         stroke
         newpath
         171 504 moveto
         441 504 lineto
         stroke
         newpath
         171 531 moveto
         441 531 lineto
         stroke
         newpath
         306 396   5   0 360 arc
         closepath stroke
         0.0000 1.0000 0.0000 setrgbcolor
         newpath
         387 477  54   0  90 arc
         stroke
         171 261 moveto
         0.0000 0.0000 0.0000 setrgbcolor
        /Palatino-Roman findfont
           0.250 inch scalefont
        setfont
        (This is "circle.plot".) show
         171 342 moveto
        /Palatino-Roman findfont
           0.125 inch scalefont
        setfont
        (This is small print.) show
        restore showpage
        %%Trailer
      INPUT
      output = <<~OUTPUT
         <image mimetype="image/svg+xml" alt="3" src="_.svg"><emf src="_.emf"/></image>
      OUTPUT
      Dir.mktmpdir(nil, Vectory.root_path.join("tmp/")) do |dir|
        expect(xmlpp(strip_guid(
          Vectory::Eps.from_content(input)
            .to_svg
            .content
            .sub(%r{<localized-strings>.*</localized-strings>}m, "")
            .gsub(%r{src="[^"]+?\.emf"}, 'src="_.emf"')
            .gsub(%r{src="[^"]+?\.svg"}, 'src="_.svg"')
        ))).to be_equivalent_to (output)
      end
    end
  end
end
