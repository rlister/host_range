require 'pp'
class HostRange

  ## wrapper returns flattened array
  def self.parse(pattern)
    parseRange(pattern).flatten
  end

  ## parse lists [123] or ranges [1-3],
  ## recurses until all [...] patterns have been subbed (left to right)
  def self.parseRange(pattern)
    string = pattern.dup               # arg is immutable

    ## list like [123] is split into atoms 1,2,3
    if string.sub!(/\[(\w+)\]/, "%s") 
      $1.split(//).map { |n| parseRange(sprintf(string, n)) }

      ## comma-separated list like [01, 03, 09-12]
    elsif string.sub!(/\[([\s\w,-]+)\]/, "%s")
      $1.split(/\s*,\s*/).map do |n| 

        ## range like 09-12
        if n.sub!(/(\w+)-(\w+)/, "%s")
          ($1..$2).map { |o| parseRange(sprintf(string, o)) }

        ## simple string like 01
        else
          parseRange(sprintf(string, n))
        end
      end

      ## simple string with no more patterns to sub
    else
      [string]
    end
  end
  
end
