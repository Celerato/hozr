require 'prawn/measurement_extensions'

class MailingOverview < Prawn::Document
  include CasesHelper
  include ApplicationHelper
  
  def to_pdf(mailing)
    @mailing = mailing

    font_families.update(
      "Cholla Sans" => { :bold        => "#{RAILS_ROOT}/data/fonts/cholla/ChollSanBol.ttf",
                         :bold_italic => "#{RAILS_ROOT}/data/fonts/cholla/ChollSanBolIta.tff",
                         :normal      => "#{RAILS_ROOT}/data/fonts/cholla/ChollSanReg.ttf",
                         :italic      => "#{RAILS_ROOT}/data/fonts/cholla/ChollSanIta.ttf",
                         :thin        => "#{RAILS_ROOT}/data/fonts/cholla/ChollSanThi.ttf",
                         :thin_italic => "#{RAILS_ROOT}/data/fonts/cholla/ChollSanThiIta.tff" })

    # support page sizes
    case page.size
    when 'A4':
      font "Cholla Sans", :size => 13
    when 'A5':
      font "Cholla Sans", :size => 10
    else
      font "Cholla Sans"
    end

    # define grid
    define_grid(:columns => 11, :rows => 16, :gutter => 2) #.show_all('EEEEEE')

    # Address
    grid([0,7], [1,9]).bounding_box do
      text @mailing.doctor.praxis.honorific_prefix
      text @mailing.doctor.praxis.full_name
      text @mailing.doctor.praxis.street_address
      text @mailing.doctor.praxis.postal_code + " " + @mailing.doctor.praxis.locality
    end

    # Place'n'Date
    grid([3,7], [3,9]).bounding_box do
      text "Affoltern a. A., " + @mailing.created_at.strftime("%d.%m.%Y")
    end

    # Subject
    grid([4,0], [4,9]).bounding_box do
      font "Cholla Sans", :style => :bold do
        text "Befundübersicht"
      end
    end

    classification_groups = ClassificationGroup.all(:order => 'position DESC')
    cases = @mailing.cases

    for group in classification_groups
      group_cases = cases.finished.by_classification_group(group).find(:all, :order => 'praxistar_eingangsnr')

      # Skip if no entries
      next if group_cases.empty?

      # Table content creation.
      items = group_cases.map do |item|
        row = [
          make_cell(:content => item.patient.name),
          make_cell(:content => item.patient.birth_date),
          make_cell(:content => item.control_findings.map {|f| html_unescape(f.name)}.join("\n")),
          make_cell(:content => item.examination_date.strftime('%d.%m.%Y')),
          make_cell(:content => item.praxistar_eingangsnr)
        ]
      end

      # Table header creation.
      headers = [[
        make_cell(:content => "#{group.title} <i>(#{items.count})</i>", :inline_format => true),
        "Geb.",
         "",
         "Entn.",
         "Eing.Nr."
      ]]

      # Table creation.
      table headers + items, :header => true,
                                 :width => margin_box.width,
                                 :cell_style => { :overflow => :shrink_to_fit, :min_font_size => 8 } do

        # General cell styling
        cells.align  = :left
        cells.valign = :top
        cells.border_width = 0
        cells.size = 10
        cells.padding = [0, 5, 0, 5]
        column(0).padding_left = 0
        column(-1).padding_right = 0

        # Headings styling
        row(0).font_style = :italic
        row(0).column(0).font_style = :bold
        row(0).padding_top = 3
        row(0).padding_bottom = 3
        row(0).background_color = group.print_color

        # Footer
        row(-1).borders = [:bottom]
        row(-1).border_width = 1
        row(-1).border_color = 'CCCCCC'
        row(-1).padding_bottom = 5

        # Columns width
        column(1).width = 1.8.cm
        column(2).width = 6.cm
        column(3).width = 1.8.cm
        column(4).width = 1.8.cm

        # Columns align
        column(1).align = :right
        column(3).align = :right
        column(4).align = :right

        # Columns colors
        column(0).row(1..-1).text_color = '660000'
        column(4).row(1..-1).text_color = '660000'

        # Columns style
        column(0).font_style = :bold
        column(2).font_style = :bold
      end

      move_down 10
    end
    
    render
  end
end